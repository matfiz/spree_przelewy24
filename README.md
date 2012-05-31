SpreePrzelewy24
====================

Przelewy24 payment system for Spree (>= 1.0)

Install
=======

Add to your Gemfile:

    gem 'spree_przelewy24', :git => 'git://github.com/matfiz/spree_przelewy24.git'

and run 

    bundle install

Przelewy24.pl Settings
========

You'll have to set the following parameters:
  * seller ID
  * CRC key
  * success and error URL

This work based on https://github.com/pronix/spree-ebsin and https://github.com/espresse/spree_dotpay_pl_payment.git.
 
