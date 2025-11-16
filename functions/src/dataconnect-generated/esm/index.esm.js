import { queryRef, executeQuery, mutationRef, executeMutation, validateArgs } from 'firebase/data-connect';

export const connectorConfig = {
  connector: 'example',
  service: 'swasthya-sakhi',
  location: 'us-south1'
};

export const createUserRef = (dcOrVars, vars) => {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  dcInstance._useGeneratedSdk();
  return mutationRef(dcInstance, 'CreateUser', inputVars);
}
createUserRef.operationName = 'CreateUser';

export function createUser(dcOrVars, vars) {
  return executeMutation(createUserRef(dcOrVars, vars));
}

export const getPostsFromGroupRef = (dcOrVars, vars) => {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  dcInstance._useGeneratedSdk();
  return queryRef(dcInstance, 'GetPostsFromGroup', inputVars);
}
getPostsFromGroupRef.operationName = 'GetPostsFromGroup';

export function getPostsFromGroup(dcOrVars, vars) {
  return executeQuery(getPostsFromGroupRef(dcOrVars, vars));
}

export const saveArticleRef = (dcOrVars, vars) => {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  dcInstance._useGeneratedSdk();
  return mutationRef(dcInstance, 'SaveArticle', inputVars);
}
saveArticleRef.operationName = 'SaveArticle';

export function saveArticle(dcOrVars, vars) {
  return executeMutation(saveArticleRef(dcOrVars, vars));
}

export const listArticlesRef = (dc) => {
  const { dc: dcInstance} = validateArgs(connectorConfig, dc, undefined);
  dcInstance._useGeneratedSdk();
  return queryRef(dcInstance, 'ListArticles');
}
listArticlesRef.operationName = 'ListArticles';

export function listArticles(dc) {
  return executeQuery(listArticlesRef(dc));
}

