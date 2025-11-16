const { queryRef, executeQuery, mutationRef, executeMutation, validateArgs } = require('firebase/data-connect');

const connectorConfig = {
  connector: 'example',
  service: 'swasthya-sakhi',
  location: 'us-south1'
};
exports.connectorConfig = connectorConfig;

const createUserRef = (dcOrVars, vars) => {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  dcInstance._useGeneratedSdk();
  return mutationRef(dcInstance, 'CreateUser', inputVars);
}
createUserRef.operationName = 'CreateUser';
exports.createUserRef = createUserRef;

exports.createUser = function createUser(dcOrVars, vars) {
  return executeMutation(createUserRef(dcOrVars, vars));
};

const getPostsFromGroupRef = (dcOrVars, vars) => {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  dcInstance._useGeneratedSdk();
  return queryRef(dcInstance, 'GetPostsFromGroup', inputVars);
}
getPostsFromGroupRef.operationName = 'GetPostsFromGroup';
exports.getPostsFromGroupRef = getPostsFromGroupRef;

exports.getPostsFromGroup = function getPostsFromGroup(dcOrVars, vars) {
  return executeQuery(getPostsFromGroupRef(dcOrVars, vars));
};

const saveArticleRef = (dcOrVars, vars) => {
  const { dc: dcInstance, vars: inputVars} = validateArgs(connectorConfig, dcOrVars, vars, true);
  dcInstance._useGeneratedSdk();
  return mutationRef(dcInstance, 'SaveArticle', inputVars);
}
saveArticleRef.operationName = 'SaveArticle';
exports.saveArticleRef = saveArticleRef;

exports.saveArticle = function saveArticle(dcOrVars, vars) {
  return executeMutation(saveArticleRef(dcOrVars, vars));
};

const listArticlesRef = (dc) => {
  const { dc: dcInstance} = validateArgs(connectorConfig, dc, undefined);
  dcInstance._useGeneratedSdk();
  return queryRef(dcInstance, 'ListArticles');
}
listArticlesRef.operationName = 'ListArticles';
exports.listArticlesRef = listArticlesRef;

exports.listArticles = function listArticles(dc) {
  return executeQuery(listArticlesRef(dc));
};
