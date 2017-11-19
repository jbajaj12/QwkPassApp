#!/usr/bin/env python
#title           :Termial_Code.py
#description     :Import data from a Firebase
#author          :Brendan Hart
#date            :10/15/2017
#version         :1.0
#usage           :python pyscript.py
#notes           : Qwkpass Terminal Script  
#python_version  :3.6.1
#==============================================================================

#Libraries
import firebase
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import auth
from firebase import firebase
import stripe
import requests
import datetime
import time
import glob
import json
import sys
import os

#API Token
stripe.api_key = 'sk_test_TdclpRssaEx5YI1mr5sVOdJu'
token = 'AIzaSyBIzEsqTlE5GvUHS1ZBxR8BNDnwGYzfxk4'
DNS = 'https://qwkpass.firebaseio.com/'
DNSUSERS = 'https://qwkpass.firebaseio.com/Users'
path = r'C:\Users/Brendan\Desktop\qwkpass-firebase-adminsdk-nsrie-62475f3567.json'
users = '/Users'

#Authentication
cred = credentials.Certificate(path)
default_app = firebase_admin.initialize_app(cred)
db = firebase.FirebaseApplication(DNS)

#Main
while 1==1:
    charge = []

    #Scan User 
    name = input('Please scan your pass to exit! \n')

    #Convert User to str
    info = db.get(users, name)
    info_str = (str(info))

    if info_str == 'None':
        print("Case 1")
        print('Error! You are not registered!')

    else:
        #Pulls All Users
        info = db.get(DNS, None)

        #Pulls Single User Start Location
        location = info['Users'][name]['Start Location']

        #Pulls Single User Stripe Token
        stripe_token = info['Users'][name]['Card Info']['Stripe Token']

        #Pulls Single User Email
        Useremail = info['Users'][name]['Email']

        #Pulls Single User Stripe Id
        stripe_id = info['Users'][name]['Stripe Id']

        #Open the Charge Table JSON File
        with open('Bart_Charge_Table.json') as json_file:
            data = json.load(json_file)
            json_file.close()
        #Pull from JSON
        charge_location = data['Start Location'][location]
        for i in charge_location:
            charge.append(i['SFO'])#Set to the SFO Terminal
        price = int(charge[0])
        
        if stripe_id == 'None':

            print("Case 2")
            
            #Creating Customer
            customer = stripe.Customer.create(
                email = Useremail,
                source = stripe_token,
                )
            customer_id = customer.id
            db.put(DNS + 'Users/' + name, 'Stripe Id', customer_id)

            # Charge the user's card:
            stripe.Charge.create(
              amount = price,
              currency = "usd",
              description = "Qwkpass",
              customer = customer_id,
            )

            #Deletes Start Location from User profile
            db.delete(DNS + 'Users/' + name, 'Start Location')
            
        else:

            print("Case 3")
            
            #Charge the user's card:
            stripe.Charge.create(
              amount = price,
              currency = "usd",
              description = "Qwkpass",
              customer = stripe_id,
            )

            #Deletes Start Location from User profile
            db.delete(DNS + 'Users/' + name, 'Start Location')






