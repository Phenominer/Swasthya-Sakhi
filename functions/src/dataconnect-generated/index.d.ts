import { ConnectorConfig, DataConnect, QueryRef, QueryPromise, MutationRef, MutationPromise } from 'firebase/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;




export interface Article_Key {
  id: UUIDString;
  __typename?: 'Article_Key';
}

export interface Comment_Key {
  id: UUIDString;
  __typename?: 'Comment_Key';
}

export interface CreateUserData {
  user_insert: User_Key;
}

export interface CreateUserVariables {
  displayName: string;
  email: string;
}

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

export interface GetPostsFromGroupVariables {
  groupId: UUIDString;
}

export interface Group_Key {
  id: UUIDString;
  __typename?: 'Group_Key';
}

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

export interface Post_Key {
  id: UUIDString;
  __typename?: 'Post_Key';
}

export interface SaveArticleData {
  savedArticle_insert: SavedArticle_Key;
}

export interface SaveArticleVariables {
  userId: UUIDString;
  articleId: UUIDString;
}

export interface SavedArticle_Key {
  userId: UUIDString;
  articleId: UUIDString;
  __typename?: 'SavedArticle_Key';
}

export interface User_Key {
  id: UUIDString;
  __typename?: 'User_Key';
}

interface CreateUserRef {
  /* Allow users to create refs without passing in DataConnect */
  (vars: CreateUserVariables): MutationRef<CreateUserData, CreateUserVariables>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect, vars: CreateUserVariables): MutationRef<CreateUserData, CreateUserVariables>;
  operationName: string;
}
export const createUserRef: CreateUserRef;

export function createUser(vars: CreateUserVariables): MutationPromise<CreateUserData, CreateUserVariables>;
export function createUser(dc: DataConnect, vars: CreateUserVariables): MutationPromise<CreateUserData, CreateUserVariables>;

interface GetPostsFromGroupRef {
  /* Allow users to create refs without passing in DataConnect */
  (vars: GetPostsFromGroupVariables): QueryRef<GetPostsFromGroupData, GetPostsFromGroupVariables>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect, vars: GetPostsFromGroupVariables): QueryRef<GetPostsFromGroupData, GetPostsFromGroupVariables>;
  operationName: string;
}
export const getPostsFromGroupRef: GetPostsFromGroupRef;

export function getPostsFromGroup(vars: GetPostsFromGroupVariables): QueryPromise<GetPostsFromGroupData, GetPostsFromGroupVariables>;
export function getPostsFromGroup(dc: DataConnect, vars: GetPostsFromGroupVariables): QueryPromise<GetPostsFromGroupData, GetPostsFromGroupVariables>;

interface SaveArticleRef {
  /* Allow users to create refs without passing in DataConnect */
  (vars: SaveArticleVariables): MutationRef<SaveArticleData, SaveArticleVariables>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect, vars: SaveArticleVariables): MutationRef<SaveArticleData, SaveArticleVariables>;
  operationName: string;
}
export const saveArticleRef: SaveArticleRef;

export function saveArticle(vars: SaveArticleVariables): MutationPromise<SaveArticleData, SaveArticleVariables>;
export function saveArticle(dc: DataConnect, vars: SaveArticleVariables): MutationPromise<SaveArticleData, SaveArticleVariables>;

interface ListArticlesRef {
  /* Allow users to create refs without passing in DataConnect */
  (): QueryRef<ListArticlesData, undefined>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect): QueryRef<ListArticlesData, undefined>;
  operationName: string;
}
export const listArticlesRef: ListArticlesRef;

export function listArticles(): QueryPromise<ListArticlesData, undefined>;
export function listArticles(dc: DataConnect): QueryPromise<ListArticlesData, undefined>;

