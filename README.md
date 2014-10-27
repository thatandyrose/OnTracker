# [OnTracker](http://ontracker.herokuapp.com)

## What you need to know

- This is a Ruby on Rails application
- This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
- It requires ruby 2.1.2
- It requires rails 4.1.5
- There is one test which requires the selenium driver, so the latest version of Firefox is required.
- Data store is postgres
- It's tested with Rspec and capybara

## Great! But what is it?

This is a simple Ticket tracking app.

It allows authenticated users to:

- views open, close, unassigned, by status tickets.
- search tickets by subject, email, body, reference.
- change ticket statuses.
- take ownership of tickets.
- comment on tickets.

Non authenticated users can only view tickets, and comment on them.

## Can I get more details on the implementation of this app please?

Sure! More thorough info the choices for this app can be found in the descriptice Pull Requests!

[Pull Requests](https://github.com/thatandyrose/OnTracker/pulls?q=is%3Apr+is%3Aclosed)

## Cool, is this continoulsly integrated?

Yes! It's on [CircleCI](https://circleci.com/gh/thatandyrose/OnTracker)

## Saweet, is it deployed also?

YES! [http://ontracker.herokuapp.com](http://ontracker.herokuapp.com)

## How the heck do I create new tickets?

Glad you asked! Check out the API docs, you can get to them via the landing page.

[http://ontracker.herokuapp.com](http://ontracker.herokuapp.com)
