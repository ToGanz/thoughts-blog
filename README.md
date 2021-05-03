# Thoughts Blog

A simple blog page written in Ruby on Rails

I made this as a refresher on authentication and authorization.
I wanted to go back and make my own authentication system without the devise gem. This way I can understand devise better when i use it in the future.
As a guideline I used Michael Hartl's Ruby course. [https://www.railstutorial.org/]

Another point I practiced with this app was testing. I used minitest and tried to achieve a good test coverage.
The main benefit I saw from testing is, that you can come back to the code a few days later and continue coding without breaking everything.

The frontend is not really fleshed out and mostly done with css-grid.


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

## Implementation of the authentication

### Sign up

#### Create a model

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


  3. In the Gemfile, uncomment the **bcrypt** gem.
    In order to save passwords securely, has_secure_password uses an algorithm called bcrypt.
    
    ```ruby
    # Use ActiveModel has_secure_password
    gem 'bcrypt', '~> 3.1.7'
    ```


  4. **Install** the gems


  5. **Add columns**  to the migration file in db/migrate/ for the users table.
    For example:
    ```ruby
    class CreateUsers < ActiveRecord::Migration
      def change
        create_table :users do |t|
          t.string :name
          t.string :email
          t.string :password_digest
          t.timestamps
        end
      end
    end
    ```

    ##### Encryption
    What’s the `password_digest` column for? When a user submits their password, it’s not a good idea to store that password as is in the database; if an attacker somehow gets into your database, they would be able to see all your users’ passwords.

    One way to defend against this is to store passwords as encrypted strings in the database. This is what the `has_secure_password` method helps with - it uses the bcrypt algorithm to securely hash a user’s password, which then gets saved in the `password_digest` column.

    Then when a user logs in again,`has_secure_password` will collect the password that was submitted, hash it with bcrypt, and check if it matches the hash in the database.


  6. Run a **migration** to update the database.

    ```bash
    rails db:migrate
    ```


  7. add **validations** to the model
    For example:
    ```ruby
    before_save   :downcase_email

    validates :name, presence: true, length: { minimum: 2, maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    private

    def downcase_email
      self.email.downcase!
    end
    ```


#### Create a controller
  1. Generate the **Users controller.**

    ```bash
    rails generate controller Users
    ```

  2. In the routes file, add these **routes**:

    ```ruby
    get 'signup'  => 'users#new' 
    resources :users 
    ```

  3. In the Users controller add the **new** action.

    ```ruby
    def new
      @user = User.new
    end
    ```

  4. Set up the form in **app/views/users/new.html.erb.**

    ```html
    <%= form_with(model: @user, local: true) do |f| %>

      <%= f.label :name %>
      <%= f.text_field :name %>

      <%= f.label :email %>
      <%= f.email_field :email %>

      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.label :password_confirmation %>
      <%= f.password_field :password_confirmation %>

      <%= f.submit %>
    <% end %>
    ```

5. Take in data submitted through the signup form and save it to the database.

    In the Users controller, add a private method **user_params**.

    ```ruby
    private

      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end

    ```

    Add the **create** action.

    ```ruby
    def create 
      @user = User.new(user_params) 
      if @user.save 
        session[:user_id] = @user.id 
        redirect_to '/' 
      else 
        redirect_to '/signup' 
      end 
    end
    ```

    - Session

        A session begins when a users logs in, and ends when a user logs out.

        How is a new session created? Sessions are stored as key/value pairs. In the `create` action, the line

        ```ruby
        session[:user_id] = @user.id 

        ```

        creates a new session by taking the value `@user.id` and assigning it to the key `:user_id`.


   