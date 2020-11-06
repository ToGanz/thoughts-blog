## Thoughts Blog

A simple blog page written in Ruby on Rails

I made this as a refresher on authentication and authorization.
I wanted to go back and make my own authentication system without the devise gem. This way I can understand devise better when i use it in the future.

Another point I practiced with this app was testing. I used minitest and tried to achieve a good test coverage.
The main benefit I saw from testing is, that you can come back to the code a few days later and continue coding without breaking everything.

The frontend is mostly done with css-grid.

Check the site out live: https://thoughts-of-coders.herokuapp.com/

Notes on the Authorization:
* Everyone can read posts
* Only Admins can create/edit/destroy posts
* Only Admins can delete users
* Every logged in user can comment
* Only Admins can delete comments
