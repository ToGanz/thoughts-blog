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

## Implementaion of the Authentication and Authorization
* [Authentication](#implementaion-of-the-authentication)
  * [Sign up](#sign-up)
    * [Create a model](#create-a-model)
    * [Create a controller](#create-a-controller)
  * [Login](#login)
  * [Logout](#logout)
  * [Checking for logged in users](#checking-for-logged-in-users)
* [Authorization](#implementation-of-the-authorization)
  * [Add a user role](#add-a-user-role)   
  * [Add require method](#add-require-method)   


## Implementation of the authentication

### Sign up

### Create a model

  1. Generate the **User model**
  ```
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


  7. add **validations** to the model.

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


### Create a controller
  1. Generate the **Users controller.**
  ```bash
  rails generate controller Users
  ```

  2. In the routes file, add these **routes**:
  ```ruby
  get 'signup'  => 'users#new' 
  resources :users 
  ```

  3. In the Users controller add the **new** action
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

### Login
1. Generate a **Sessions** controller.

  ```bash
  rails generate controller Sessions
  ```

2. Add the login **route**.

  ```ruby
  get 'login' => 'sessions#new'
  ```

3. In the Sessions controller add the **new** action.

  ```ruby
  def new
  end
  ```


4. In *app/views/sessions/new.html.erb*, create a **login form.**

  ```html
  <%= form_with(scope: :session, url: login_path, local: true) do |f| %> 
    <%= f.email_field :email, :placeholder => "Email" %> 
    <%= f.password_field :password, :placeholder => "Password" %> 
    <%= f.submit "Log in" %>
  <% end %>
  ```

5. Set the **route** for the post of the form.

  ```ruby
  post 'login' => 'sessions#create'
  ```
  
6. Add the **create** action.

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


### Logout

1. Set the **delete** route.

  ```ruby
  delete 'logout' => 'sessions#destroy'
  ```

2. Add the **destroy** action.

  ```ruby
  def destroy 
    session[:user_id] = nil 
    redirect_to '/' 
  end
  ```


### Checking for logged in users

1. In *app/controllers/application_controller.rb*, add a method named **current_user.**

  ```ruby
  helper_method :current_user 

  def current_user 
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id] 
  end
  ```

  - Explanation
      1. The `current_user` method determines whether a user is logged in or logged out. It does this by checking whether there’s a user in the database with a given session id. If there is, this means the user is logged in and `@current_user` will store that user; otherwise the user is logged out and `@current_user` will be `nil`.
      2. The line `helper_method :current_user` makes `current_user` method available in the views. By default, all methods defined in Application Controller are already available in the controllers.

  2. In *app/controllers/application_controller.rb*, add a method named **require_user.**

  ```ruby
  def require_user 
    redirect_to '/login' unless current_user 
  end
  ```

  - Explanation

      The `require_user`  method uses the `current_user`  method to redirect logged out users to the login page.

3. To prevent logged out users from accessing certain resources, you can use a **before action** with require_user in the corresponding controller.

  ```ruby
  before_action :require_user, only: [:edit, :update, :destroy]
  ```


4. Of course, requiring users to log in isn’t quite enough; users should only be allowed to edit their own information.
  * Add  `require_correct_user` method to *app/controller/users_controller.rb* 

  ```ruby
  def require_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user && @user == current_user
  end
  ```

  * add before action to the controller

  ```ruby
  before_action :require_correct_user, only: [:edit, :update, :destroy]
  ```

5. In *app/controllers/application_controller.rb*, add a method named **logged_in?.**

  ```ruby
  helper_method :logged_in? 

  def logged_in?
    !!current_user
  end
  ```

  - Explanation

      A boolean method for use in the views


6. You can use `logged_in?` in **application layout** to update the nav items depending on whether a user is logged in or out. In **app/views/layouts/application.html.erb.**

  ```html
  <% if logged_in? %> 
    <ul> 
      <li><%= current_user.email %></li> 
      <li><%= link_to "Log out", logout_path, method: "delete" %></li> 
    </ul> 
  <% else %> 
    <ul> 
      <li><%= link_to "Login", 'login' %></a></li> 
      <li><%= link_to "Signup", 'signup' %></a></li> 
    </ul> 
  <% end %> 

  ```
   

## Implementation of the Authorization

### Add a user role
1. Generate a migration

  ```bash
    rails generate migration AddRoleToUsers role:string
  ```

2. In the migration file, add a string column called **role** to the users table.

  ```ruby
  class AddRoleToUsers < ActiveRecord::Migration
    def change
      add_column :users, :role, :string
    end
  end
  ```

3. Add a **method** to the User model that will help use the role column in our application.

  ```ruby
  def admin? 
    self.role == 'admin' 
  end
  ```

### Add require method

1. In the Application controller (app/controllers/application_controller.rb), add another method named **require_admin**

  ```ruby
  def require_admin 
    redirect_to '/' unless current_user.admin? 
  end
  ```

2. Use the require method as a **before filter** for the actions of the corresponding controller.

  ```ruby
  before_action :require_admin, only: [:show, :edit]
  ```

3. Then in the **view** use the admin? method to display an edit link only if a user is an admin.

  ```ruby
  <% if current_user && current_user.admin? %> 
    <p class="post-edit"> 
      <%= link_to "Edit Post", edit_post_path(@post.id) %> 
    </p> 
  <% end %>
  ```