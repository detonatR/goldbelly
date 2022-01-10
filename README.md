Thank you for taking the time to review my submission.

# To get started:

```bundle install```
```bundle exec rake db:setup```
```bundle exec rails s ```

To run the test suite:

```bundle exec rspec```

# End points:

Signing in will return headers for access token, client, and uid. To access all routes, register and sign in, then use the returned headers to authenticate your requests

POST /auth/ 
- email (string)
- password (string)
- password_confirmation (string)

POST /auth/sign_in
- email (string)
- password (string)


GET /links - returns a list of all current user links

POST /links - create a link

```
{
  link: {
    url: string,
    slug: string
  }
}
```

Slug is optional. Provide a slug if you want to use a custom slug, or leave it nil to get one generated.

PATCH /links/:id

```
{
  link: {
    expires_at: datetime
  }
}
```

DELETE /links/:id

GET /s/:slug - finds link by slug and redirects to full destination


# How the app is structured:

Slugger service initializes a new link record with either the custom slug or generated slug. From there, record is saved and sent to validation in the controller. Most validations for url and slug are handled by their respective validators. 

RedirectsController handles the redirect, while LikesController handles the usually CRUD. I seperated to separate concerns, and make it cleaner to add more on to the redirect functionality (stat tracking etc)
