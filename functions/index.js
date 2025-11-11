const batch = db.batch();
      const attendanceRef = db.collection("attendance");
      const timestamp = admin.firestore.Timestamp.fromDate(new Date(date));

      // Process each attendance record
      for (const record of attendanceData) {
        const {studentId, isPresent} = record;
        if (!studentId || isPresent === undefined) {
          console.warn("Skipping invalid attendance record:", record);
          continue; // Skip this record
        }

        const attendanceId = `${courseId}_${studentId}_${date}`;

        const attendanceRecord = {
          id: attendanceId,
          studentId,
          courseId,
          date: timestamp,
          isPresent: Boolean(isPresent),
          markedBy: callerUid,
          markedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        batch.set(
            attendanceRef.doc(attendanceId), attendanceRecord, {merge: true},
        );
      }

      // Commit the batch
      await batch.commit();

      return {success: true, message: "Attendance marked successfully"};
    });

/**
 * Get attendance summary for a student in a course
 */
exports.getAttendanceSummary = functions.region(region).https
    .onCall(async (data, context) => {
      if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated", "User not authenticated",
        );
      }

      const {studentId, courseId} = data;
      const callerUid = context.auth.uid;
      const callerDoc = await db.collection("users").doc(callerUid).get();
      const callerData = callerDoc.data();

      if (!callerData) {
        throw new functions.https.HttpsError(
            "unauthenticated", "Caller profile not found.",
        );
      }

      // Verify the caller has permission to view this data
      if (
        callerData.role !== "admin" &&
      callerData.role !== "faculty" &&
      callerUid !== studentId
      ) {
        throw new functions.https.HttpsError(
            "permission-denied", "Not authorized to view this data",
        );
      }

      // Get all attendance records for this student in the specified course
      const snapshot = await db.collection("attendance")
          .where("studentId", "==", studentId)
          .where("courseId", "==", courseId)
          .get();

      const records = snapshot.docs.map((doc) => doc.data());
      const totalClasses = records.length;
      const presentCount = records.filter((record) => record.isPresent).length;
      const attendancePercentage = totalClasses > 0 ?
        Math.round((presentCount / totalClasses) * 100) :
        0;

      return {
        totalClasses,
        present: presentCount,
        absent: totalClasses - presentCount,
        attendancePercentage,
        records: records.map((record) => ({
          date: record.date.toDate().toISOString().split("T")[0],
          isPresent: record.isPresent,
          markedBy: record.markedBy,
          markedAt: record.markedAt.toDate().toISOString(),
        })),
      };
    });

/**
 * Get all courses for a user (student or faculty)
 */
exports.getUserCourses = functions.region(region).https
    .onCall(async (data, context) => {
      if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated", "User not authenticated",
        );
      }

      const userId = context.auth.uid;
      const userDoc = await db.collection("users").doc(userId).get();
      const userData = userDoc.data();

      if (!userData) {
        throw new functions.https.HttpsError("not-found", "User not found",);
      }

      let query;

      if (userData.role === "student") {
        // For students, get courses they are enrolled in
        query = db.collection("courses")
            .where("studentIds", "array-contains", userId);
      } else if (userData.role === "faculty") {
        // For faculty, get courses they teach
        query = db.collection("courses").where("facultyId", "==", userId);
      } else if (userData.role === "admin") {
        // For admins, get all courses
        query = db.collection("courses");
      } else {
        return [];
      }

      const snapshot = await query.get();
      return snapshot.docs.map((doc) => {
        const data = doc.data();
        return {
          id: doc.id,
          ...data,
          // Convert Firestore timestamps to ISO strings
          // --- FIX 2: Replaced 'data.createdAt?.toDate()...' ---
          createdAt: (data.createdAt &&
            data.createdAt.toDate().toISOString()) || null,
          // --- FIX 3: Replaced 'data.updatedAt?.toDate()...' ---
          updatedAt: (data.updatedAt &&
            data.updatedAt.toDate().toISOString()) || null,
        };
      });
    });

