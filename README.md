Solstice - Flutter Application

Welcome to the Solstice flutter app. The purpose of this application is to display a list of terms and conditions,
and provide functionalities to add or edit new terms and conditions.

State Management with RiverPod

RiverPod is state management tool and also reactive framework for flutter, we have used RiverPod in this project to mange state,

Clean architecture

We have used Clean architecture to build this project, as it is more helpful to keep the code clean, Clean architecture contains three layers

1)presentation layer => This layer contains the user interface components, such as widgets, screens, and views. 
It is responsible for handling user interactions and rendering the UI.

2)Domain Layer => The domain layer represents the core business logic of the application. It contains use cases, entities, and business rules.

3)Data Layer => The data layer is responsible for data retrieval and storage. It consists of repositories and data sources.

Terms and Conditions

We store the list of terms and condition in json file in assets directory and set the path in pubspec.yaml,
to fetch the terms and condition, we have used repository pattern with RiverPod. 


UI

Terms Screen(Main screen)

The main screen represent the terms and condition in listview format, and user is able to add new and edit existing terms and condition

Add/update Term Bottom Sheet

This bottom sheet represent the UI which used to adding or updating new terms and conditions, it provide TextField and Speech-to-text functionality,
user can choose whether to use TextField or Speech-to-text functionality, Speech-to-text functionality make easy for user to add terms without interacting with KeyBord

Translation (English to hindi)

We have implemented Google ML Kit Translation package to translate the language from english to hindi,
which allow to translate between two language

Permission

we have used the permission_handler package,
to make sure that the app handles require permissions appropriately in android and ios devices.

Speech to Text for voice input

we have implemented the speech_to_text package, 
This feature helps users to add terms and conditions via voice input.


                                #### Guide on How to use App ####

step on how to use the app:

 1: Home Screen
once app is lunch, it will open home screen

 2: Terms and Conditions
There will be the list of terms and condition and "Read in Hindi" button in bottom right.

 3: How to translate Text in Hindi
by taping on "Read in hindi" button, english text will be translated into hindi language.

 4: How to Edit Terms and Conditions
by taping on item it will open bottom sheet with "TextField" and "update" button, after making changes in "TextField", 
click on Update button and it will edit the item.

 5: How to Add New Terms and Conditions
At the end of the list, user will find an option to "Add More.",it will open bottom sheet with "TextField" and "update" button,
after adding new text in "TextField", click on confirm button to add new item, and also there is microphone option to add new terms and condition.

 6: How to Translate Written Text to Hindi
by taping on "View in hindi" button, Text which is written in "TextField" will be translated into hindi language.

That is end of guide of how to use the app!