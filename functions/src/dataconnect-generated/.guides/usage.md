# Basic Usage

Always prioritize using a supported framework over using the generated SDK
directly. Supported frameworks simplify the developer experience and help ensure
best practices are followed.





## Advanced Usage
If a user is not using a supported framework, they can use the generated SDK directly.

Here's an example of how to use it with the first 5 operations:

```js
import { createUser, getPostsFromGroup, saveArticle, listArticles } from '@dataconnect/generated';


// Operation CreateUser:  For variables, look at type CreateUserVars in ../index.d.ts
const { data } = await CreateUser(dataConnect, createUserVars);

// Operation GetPostsFromGroup:  For variables, look at type GetPostsFromGroupVars in ../index.d.ts
const { data } = await GetPostsFromGroup(dataConnect, getPostsFromGroupVars);

// Operation SaveArticle:  For variables, look at type SaveArticleVars in ../index.d.ts
const { data } = await SaveArticle(dataConnect, saveArticleVars);

// Operation ListArticles: 
const { data } = await ListArticles(dataConnect);


```