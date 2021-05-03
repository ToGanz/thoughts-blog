## Thoughts Blog

A simple blog page written in Ruby on Rails

I made this as a refresher on authentication and authorization.
I wanted to go back and make my own authentication system without the devise gem. This way I can understand devise better when i use it in the future.
As a guideline I used Michael Hartl's Ruby course. [https://www.railstutorial.org/]

Another point I practiced with this app was testing. I used minitest and tried to achieve a good test coverage.
The main benefit I saw from testing is, that you can come back to the code a few days later and continue coding without breaking everything.

The frontend is not really fleshed out and mostly done with css-grid.

### Implementation of the authentication
* To save the password securely i used the bcrypt gem. 

When a user submits their password, it’s not a good idea to store that password as is in the database; if an attacker somehow gets into the database, they would be able to see all of the users’ passwords.
One way to defend against this is to store passwords as encrypted strings in the database. 


To do this I added the method "has_secure_password" to the User Model.
```ruby
class User < ActiveRecord::Base 

  has_secure_password 

end
```
This method uses the bcrypt algorithm to securely hash a user’s password, which then gets saved in a password_digest column.
Then when a user logs in again, "has_secure_password" will collect the password that was submitted, hash it with bcrypt, and check if it matches the hash in the database.

The create method for logging in looks like this:
```ruby
def create
  @user = User.find_by_email(params[:session][:email].downcase)
  if @user && @user.authenticate(params[:session][:password])
    session[:user_id] = @user.id
    redirect_to '/'
  else
    render 'new'
  end 
end
```
The authenticate method is used to check if the provided password matches the stored password_digest


![image](https://user-images.githubusercontent.com/49613341/116801307-e0878d00-ab08-11eb-86c4-bcc2d4d76ee1.png)


Check the site out live: [https://thoughts-of-coders.herokuapp.com/]


Notes on the Authorization:
* Everyone can read posts
* Only Admins can create/edit/destroy posts
* Only Admins can delete users
* Every logged in user can comment
* Only Admins can delete comments

* If you want to test the app as an admin just look at:
  test@test.com
  password

### Implementation of the authentication

#### Sign up

* Create a model

  1. Generate the **User model**
  ```bash
  rails generate model User
  ```
  2. In *app/models/user.rb*, add a method named **has_secure_password**. 
  (adds functionality to save passwords securely)
  ```ruby
  class User < ActiveRecord::Base 

    has_secure_password 

  end
  ```

