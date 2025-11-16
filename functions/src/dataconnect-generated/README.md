# Generated TypeScript README
This README will guide you through the process of using the generated JavaScript SDK package for the connector `example`. It will also provide examples on how to use your generated SDK to call your Data Connect queries and mutations.

***NOTE:** This README is generated alongside the generated SDK. If you make changes to this file, they will be overwritten when the SDK is regenerated.*

# Table of Contents
- [**Overview**](#generated-javascript-readme)
- [**Accessing the connector**](#accessing-the-connector)
  - [*Connecting to the local Emulator*](#connecting-to-the-local-emulator)
- [**Queries**](#queries)
  - [*GetPostsFromGroup*](#getpostsfromgroup)
  - [*ListArticles*](#listarticles)
- [**Mutations**](#mutations)
  - [*CreateUser*](#createuser)
  - [*SaveArticle*](#savearticle)

# Accessing the connector
A connector is a collection of Queries and Mutations. One SDK is generated for each connector - this SDK is generated for the connector `example`. You can find more information about connectors in the [Data Connect documentation](https://firebase.google.com/docs/data-connect#how-does).

You can use this generated SDK by importing from the package `@dataconnect/generated` as shown below. Both CommonJS and ESM imports are supported.

You can also follow the instructions from the [Data Connect documentation](https://firebase.google.com/docs/data-connect/web-sdk#set-client).

```typescript
import { getDataConnect } from 'firebase/data-connect';
import { connectorConfig } from '@dataconnect/generated';

const dataConnect = getDataConnect(connectorConfig);
```

## Connecting to the local Emulator
By default, the connector will connect to the production service.

To connect to the emulator, you can use the following code.
You can also follow the emulator instructions from the [Data Connect documentation](https://firebase.google.com/docs/data-connect/web-sdk#instrument-clients).

```typescript
import { connectDataConnectEmulator, getDataConnect } from 'firebase/data-connect';
import { connectorConfig } from '@dataconnect/generated';

const dataConnect = getDataConnect(connectorConfig);
connectDataConnectEmulator(dataConnect, 'localhost', 9399);
```

After it's initialized, you can call your Data Connect [queries](#queries) and [mutations](#mutations) from your generated SDK.

# Queries

There are two ways to execute a Data Connect Query using the generated Web SDK:
- Using a Query Reference function, which returns a `QueryRef`
  - The `QueryRef` can be used as an argument to `executeQuery()`, which will execute the Query and return a `QueryPromise`
- Using an action shortcut function, which returns a `QueryPromise`
  - Calling the action shortcut function will execute the Query and return a `QueryPromise`

The following is true for both the action shortcut function and the `QueryRef` function:
- The `QueryPromise` returned will resolve to the result of the Query once it has finished executing
- If the Query accepts arguments, both the action shortcut function and the `QueryRef` function accept a single argument: an object that contains all the required variables (and the optional variables) for the Query
- Both functions can be called with or without passing in a `DataConnect` instance as an argument. If no `DataConnect` argument is passed in, then the generated SDK will call `getDataConnect(connectorConfig)` behind the scenes for you.

Below are examples of how to use the `example` connector's generated functions to execute each query. You can also follow the examples from the [Data Connect documentation](https://firebase.google.com/docs/data-connect/web-sdk#using-queries).

## GetPostsFromGroup
You can execute the `GetPostsFromGroup` query using the following action shortcut function, or by calling `executeQuery()` after calling the following `QueryRef` function, both of which are defined in [dataconnect-generated/index.d.ts](./index.d.ts):
```typescript
getPostsFromGroup(vars: GetPostsFromGroupVariables): QueryPromise<GetPostsFromGroupData, GetPostsFromGroupVariables>;

interface GetPostsFromGroupRef {
  ...
  /* Allow users to create refs without passing in DataConnect */
  (vars: GetPostsFromGroupVariables): QueryRef<GetPostsFromGroupData, GetPostsFromGroupVariables>;
}
export const getPostsFromGroupRef: GetPostsFromGroupRef;
```
You can also pass in a `DataConnect` instance to the action shortcut function or `QueryRef` function.
```typescript
getPostsFromGroup(dc: DataConnect, vars: GetPostsFromGroupVariables): QueryPromise<GetPostsFromGroupData, GetPostsFromGroupVariables>;

interface GetPostsFromGroupRef {
  ...
  (dc: DataConnect, vars: GetPostsFromGroupVariables): QueryRef<GetPostsFromGroupData, GetPostsFromGroupVariables>;
}
export const getPostsFromGroupRef: GetPostsFromGroupRef;
```

If you need the name of the operation without creating a ref, you can retrieve the operation name by calling the `operationName` property on the getPostsFromGroupRef:
```typescript
const name = getPostsFromGroupRef.operationName;
console.log(name);
```

### Variables
The `GetPostsFromGroup` query requires an argument of type `GetPostsFromGroupVariables`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:

```typescript
export interface GetPostsFromGroupVariables {
  groupId: UUIDString;
}
```
### Return Type
Recall that executing the `GetPostsFromGroup` query returns a `QueryPromise` that resolves to an object with a `data` property.

The `data` property is an object of type `GetPostsFromGroupData`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:
```typescript
export interface GetPostsFromGroupData {
  posts: ({
    id: UUIDString;
    content: string;
    createdAt: TimestampString;
    user?: {
      id: UUIDString;
      displayName: string;
    } & User_Key;
  } & Post_Key)[];
}
```
### Using `GetPostsFromGroup`'s action shortcut function

```typescript
import { getDataConnect } from 'firebase/data-connect';
import { connectorConfig, getPostsFromGroup, GetPostsFromGroupVariables } from '@dataconnect/generated';

// The `GetPostsFromGroup` query requires an argument of type `GetPostsFromGroupVariables`:
const getPostsFromGroupVars: GetPostsFromGroupVariables = {
  groupId: ..., 
};

// Call the `getPostsFromGroup()` function to execute the query.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await getPostsFromGroup(getPostsFromGroupVars);
// Variables can be defined inline as well.
const { data } = await getPostsFromGroup({ groupId: ..., });

// You can also pass in a `DataConnect` instance to the action shortcut function.
const dataConnect = getDataConnect(connectorConfig);
const { data } = await getPostsFromGroup(dataConnect, getPostsFromGroupVars);

console.log(data.posts);

// Or, you can use the `Promise` API.
getPostsFromGroup(getPostsFromGroupVars).then((response) => {
  const data = response.data;
  console.log(data.posts);
});
```

### Using `GetPostsFromGroup`'s `QueryRef` function

```typescript
import { getDataConnect, executeQuery } from 'firebase/data-connect';
import { connectorConfig, getPostsFromGroupRef, GetPostsFromGroupVariables } from '@dataconnect/generated';

// The `GetPostsFromGroup` query requires an argument of type `GetPostsFromGroupVariables`:
const getPostsFromGroupVars: GetPostsFromGroupVariables = {
  groupId: ..., 
};

// Call the `getPostsFromGroupRef()` function to get a reference to the query.
const ref = getPostsFromGroupRef(getPostsFromGroupVars);
// Variables can be defined inline as well.
const ref = getPostsFromGroupRef({ groupId: ..., });

// You can also pass in a `DataConnect` instance to the `QueryRef` function.
const dataConnect = getDataConnect(connectorConfig);
const ref = getPostsFromGroupRef(dataConnect, getPostsFromGroupVars);

// Call `executeQuery()` on the reference to execute the query.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await executeQuery(ref);

console.log(data.posts);

// Or, you can use the `Promise` API.
executeQuery(ref).then((response) => {
  const data = response.data;
  console.log(data.posts);
});
```

## ListArticles
You can execute the `ListArticles` query using the following action shortcut function, or by calling `executeQuery()` after calling the following `QueryRef` function, both of which are defined in [dataconnect-generated/index.d.ts](./index.d.ts):
```typescript
listArticles(): QueryPromise<ListArticlesData, undefined>;

interface ListArticlesRef {
  ...
  /* Allow users to create refs without passing in DataConnect */
  (): QueryRef<ListArticlesData, undefined>;
}
export const listArticlesRef: ListArticlesRef;
```
You can also pass in a `DataConnect` instance to the action shortcut function or `QueryRef` function.
```typescript
listArticles(dc: DataConnect): QueryPromise<ListArticlesData, undefined>;

interface ListArticlesRef {
  ...
  (dc: DataConnect): QueryRef<ListArticlesData, undefined>;
}
export const listArticlesRef: ListArticlesRef;
```

If you need the name of the operation without creating a ref, you can retrieve the operation name by calling the `operationName` property on the listArticlesRef:
```typescript
const name = listArticlesRef.operationName;
console.log(name);
```

### Variables
The `ListArticles` query has no variables.
### Return Type
Recall that executing the `ListArticles` query returns a `QueryPromise` that resolves to an object with a `data` property.

The `data` property is an object of type `ListArticlesData`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:
```typescript
export interface ListArticlesData {
  articles: ({
    id: UUIDString;
    title: string;
    content: string;
    author?: string | null;
    category?: string | null;
    createdAt: TimestampString;
    imageUrl?: string | null;
  } & Article_Key)[];
}
```
### Using `ListArticles`'s action shortcut function

```typescript
import { getDataConnect } from 'firebase/data-connect';
import { connectorConfig, listArticles } from '@dataconnect/generated';


// Call the `listArticles()` function to execute the query.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await listArticles();

// You can also pass in a `DataConnect` instance to the action shortcut function.
const dataConnect = getDataConnect(connectorConfig);
const { data } = await listArticles(dataConnect);

console.log(data.articles);

// Or, you can use the `Promise` API.
listArticles().then((response) => {
  const data = response.data;
  console.log(data.articles);
});
```

### Using `ListArticles`'s `QueryRef` function

```typescript
import { getDataConnect, executeQuery } from 'firebase/data-connect';
import { connectorConfig, listArticlesRef } from '@dataconnect/generated';


// Call the `listArticlesRef()` function to get a reference to the query.
const ref = listArticlesRef();

// You can also pass in a `DataConnect` instance to the `QueryRef` function.
const dataConnect = getDataConnect(connectorConfig);
const ref = listArticlesRef(dataConnect);

// Call `executeQuery()` on the reference to execute the query.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await executeQuery(ref);

console.log(data.articles);

// Or, you can use the `Promise` API.
executeQuery(ref).then((response) => {
  const data = response.data;
  console.log(data.articles);
});
```

# Mutations

There are two ways to execute a Data Connect Mutation using the generated Web SDK:
- Using a Mutation Reference function, which returns a `MutationRef`
  - The `MutationRef` can be used as an argument to `executeMutation()`, which will execute the Mutation and return a `MutationPromise`
- Using an action shortcut function, which returns a `MutationPromise`
  - Calling the action shortcut function will execute the Mutation and return a `MutationPromise`

The following is true for both the action shortcut function and the `MutationRef` function:
- The `MutationPromise` returned will resolve to the result of the Mutation once it has finished executing
- If the Mutation accepts arguments, both the action shortcut function and the `MutationRef` function accept a single argument: an object that contains all the required variables (and the optional variables) for the Mutation
- Both functions can be called with or without passing in a `DataConnect` instance as an argument. If no `DataConnect` argument is passed in, then the generated SDK will call `getDataConnect(connectorConfig)` behind the scenes for you.

Below are examples of how to use the `example` connector's generated functions to execute each mutation. You can also follow the examples from the [Data Connect documentation](https://firebase.google.com/docs/data-connect/web-sdk#using-mutations).

## CreateUser
You can execute the `CreateUser` mutation using the following action shortcut function, or by calling `executeMutation()` after calling the following `MutationRef` function, both of which are defined in [dataconnect-generated/index.d.ts](./index.d.ts):
```typescript
createUser(vars: CreateUserVariables): MutationPromise<CreateUserData, CreateUserVariables>;

interface CreateUserRef {
  ...
  /* Allow users to create refs without passing in DataConnect */
  (vars: CreateUserVariables): MutationRef<CreateUserData, CreateUserVariables>;
}
export const createUserRef: CreateUserRef;
```
You can also pass in a `DataConnect` instance to the action shortcut function or `MutationRef` function.
```typescript
createUser(dc: DataConnect, vars: CreateUserVariables): MutationPromise<CreateUserData, CreateUserVariables>;

interface CreateUserRef {
  ...
  (dc: DataConnect, vars: CreateUserVariables): MutationRef<CreateUserData, CreateUserVariables>;
}
export const createUserRef: CreateUserRef;
```

If you need the name of the operation without creating a ref, you can retrieve the operation name by calling the `operationName` property on the createUserRef:
```typescript
const name = createUserRef.operationName;
console.log(name);
```

### Variables
The `CreateUser` mutation requires an argument of type `CreateUserVariables`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:

```typescript
export interface CreateUserVariables {
  displayName: string;
  email: string;
}
```
### Return Type
Recall that executing the `CreateUser` mutation returns a `MutationPromise` that resolves to an object with a `data` property.

The `data` property is an object of type `CreateUserData`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:
```typescript
export interface CreateUserData {
  user_insert: User_Key;
}
```
### Using `CreateUser`'s action shortcut function

```typescript
import { getDataConnect } from 'firebase/data-connect';
import { connectorConfig, createUser, CreateUserVariables } from '@dataconnect/generated';

// The `CreateUser` mutation requires an argument of type `CreateUserVariables`:
const createUserVars: CreateUserVariables = {
  displayName: ..., 
  email: ..., 
};

// Call the `createUser()` function to execute the mutation.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await createUser(createUserVars);
// Variables can be defined inline as well.
const { data } = await createUser({ displayName: ..., email: ..., });

// You can also pass in a `DataConnect` instance to the action shortcut function.
const dataConnect = getDataConnect(connectorConfig);
const { data } = await createUser(dataConnect, createUserVars);

console.log(data.user_insert);

// Or, you can use the `Promise` API.
createUser(createUserVars).then((response) => {
  const data = response.data;
  console.log(data.user_insert);
});
```

### Using `CreateUser`'s `MutationRef` function

```typescript
import { getDataConnect, executeMutation } from 'firebase/data-connect';
import { connectorConfig, createUserRef, CreateUserVariables } from '@dataconnect/generated';

// The `CreateUser` mutation requires an argument of type `CreateUserVariables`:
const createUserVars: CreateUserVariables = {
  displayName: ..., 
  email: ..., 
};

// Call the `createUserRef()` function to get a reference to the mutation.
const ref = createUserRef(createUserVars);
// Variables can be defined inline as well.
const ref = createUserRef({ displayName: ..., email: ..., });

// You can also pass in a `DataConnect` instance to the `MutationRef` function.
const dataConnect = getDataConnect(connectorConfig);
const ref = createUserRef(dataConnect, createUserVars);

// Call `executeMutation()` on the reference to execute the mutation.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await executeMutation(ref);

console.log(data.user_insert);

// Or, you can use the `Promise` API.
executeMutation(ref).then((response) => {
  const data = response.data;
  console.log(data.user_insert);
});
```

## SaveArticle
You can execute the `SaveArticle` mutation using the following action shortcut function, or by calling `executeMutation()` after calling the following `MutationRef` function, both of which are defined in [dataconnect-generated/index.d.ts](./index.d.ts):
```typescript
saveArticle(vars: SaveArticleVariables): MutationPromise<SaveArticleData, SaveArticleVariables>;

interface SaveArticleRef {
  ...
  /* Allow users to create refs without passing in DataConnect */
  (vars: SaveArticleVariables): MutationRef<SaveArticleData, SaveArticleVariables>;
}
export const saveArticleRef: SaveArticleRef;
```
You can also pass in a `DataConnect` instance to the action shortcut function or `MutationRef` function.
```typescript
saveArticle(dc: DataConnect, vars: SaveArticleVariables): MutationPromise<SaveArticleData, SaveArticleVariables>;

interface SaveArticleRef {
  ...
  (dc: DataConnect, vars: SaveArticleVariables): MutationRef<SaveArticleData, SaveArticleVariables>;
}
export const saveArticleRef: SaveArticleRef;
```

If you need the name of the operation without creating a ref, you can retrieve the operation name by calling the `operationName` property on the saveArticleRef:
```typescript
const name = saveArticleRef.operationName;
console.log(name);
```

### Variables
The `SaveArticle` mutation requires an argument of type `SaveArticleVariables`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:

```typescript
export interface SaveArticleVariables {
  userId: UUIDString;
  articleId: UUIDString;
}
```
### Return Type
Recall that executing the `SaveArticle` mutation returns a `MutationPromise` that resolves to an object with a `data` property.

The `data` property is an object of type `SaveArticleData`, which is defined in [dataconnect-generated/index.d.ts](./index.d.ts). It has the following fields:
```typescript
export interface SaveArticleData {
  savedArticle_insert: SavedArticle_Key;
}
```
### Using `SaveArticle`'s action shortcut function

```typescript
import { getDataConnect } from 'firebase/data-connect';
import { connectorConfig, saveArticle, SaveArticleVariables } from '@dataconnect/generated';

// The `SaveArticle` mutation requires an argument of type `SaveArticleVariables`:
const saveArticleVars: SaveArticleVariables = {
  userId: ..., 
  articleId: ..., 
};

// Call the `saveArticle()` function to execute the mutation.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await saveArticle(saveArticleVars);
// Variables can be defined inline as well.
const { data } = await saveArticle({ userId: ..., articleId: ..., });

// You can also pass in a `DataConnect` instance to the action shortcut function.
const dataConnect = getDataConnect(connectorConfig);
const { data } = await saveArticle(dataConnect, saveArticleVars);

console.log(data.savedArticle_insert);

// Or, you can use the `Promise` API.
saveArticle(saveArticleVars).then((response) => {
  const data = response.data;
  console.log(data.savedArticle_insert);
});
```

### Using `SaveArticle`'s `MutationRef` function

```typescript
import { getDataConnect, executeMutation } from 'firebase/data-connect';
import { connectorConfig, saveArticleRef, SaveArticleVariables } from '@dataconnect/generated';

// The `SaveArticle` mutation requires an argument of type `SaveArticleVariables`:
const saveArticleVars: SaveArticleVariables = {
  userId: ..., 
  articleId: ..., 
};

// Call the `saveArticleRef()` function to get a reference to the mutation.
const ref = saveArticleRef(saveArticleVars);
// Variables can be defined inline as well.
const ref = saveArticleRef({ userId: ..., articleId: ..., });

// You can also pass in a `DataConnect` instance to the `MutationRef` function.
const dataConnect = getDataConnect(connectorConfig);
const ref = saveArticleRef(dataConnect, saveArticleVars);

// Call `executeMutation()` on the reference to execute the mutation.
// You can use the `await` keyword to wait for the promise to resolve.
const { data } = await executeMutation(ref);

console.log(data.savedArticle_insert);

// Or, you can use the `Promise` API.
executeMutation(ref).then((response) => {
  const data = response.data;
  console.log(data.savedArticle_insert);
});
```

