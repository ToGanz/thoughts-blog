## Thoughts Blog

A simple blog page written in Ruby on Rails

I made this as a refresher on authentication and authorization.
I wanted to go back and make my own authentication system without the devise gem. This way I can understand devise better when i use it in the future.

Another point I practiced with this app was testing. I used minitest and tried to achieve a good test coverage.
The main benefit I saw from testing is, that you can come back to the code a few days later and continue coding without breaking everything.

The frontend is mostly done with css-grid.

Check the site out live: https://thoughts-of-coders.herokuapp.com/


![image](https://user-images.githubusercontent.com/49613341/116801307-e0878d00-ab08-11eb-86c4-bcc2d4d76ee1.png)



Notes on the Authorization:
* Everyone can read posts
* Only Admins can create/edit/destroy posts
* Only Admins can delete users
* Every logged in user can comment
* Only Admins can delete comments

* If you want to test the app as an admin just look at:
  test@test.com
  password
