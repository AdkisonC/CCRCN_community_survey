
# The purpose of this script is to assist James Holmquist of the Smithsonian Environmental
# Research Center in manipulating, cleaning, analyzing and ultimately displaying data 
# received from the Coastal Carbon RCN December 2017 Community Survey. 

    # Started on March 15, 2018 by Christopher Adkison, SERC Biogeochemistry Intern
    # Major workflow edits completed March 16, 2018 including connecting data to Github.


# First turn on the necessary libraries to use this script.
library(rmarkdown)
library(tidyverse)

# Upload the dataset into a tibble usig read_csv
Survey_Responses <- read_csv("Data/CCRCN_Dec2017_Survey_Reponses_PII_Scrubbed_180316.csv")
View(Survey_Responses)


# Change the column names to something easier to call in R; spaces are tricky with names.
# This step in particular is important because the google doc csv output uses the questions as 
# column names. These are far too long and need to be changed into something easier to use.
names(Survey_Responses) <- c("Timestamp", "Institution", "Title_Role",
                             "Spatial_Scale", "Career_milestone", "Work_location", "Data_synthesis",
                             "Data_access", "Make_public?", "Network_support", "Data_kind",
                             "Motivation", "Training_type", "Workshop_interest", "Workshop_idea",
                             "Workshop_worked", "Workshop_avoid", "CWCRP_5", "Feedback_concerns")


*************************************** Section 1 Questions ***********************************

1. # Which best describes your role in coastal wetland carbon science?
      # This question has 4 answers, however, the last answer choice as "other" is
      # a text field where respondents can use their own title. This is useful information
      # to have, but can become overwhelming for analysis. Using the grepl function we will
      # rename all data entries back into one of the original 4 categories and input
      # these new reformated names into a new column for simplicity's sake.

# Let's write a function to condense the similar responses into a single identifier, we'll start with scientists.
scientist = grepl("Scientist", Survey_Responses$Title_Role)
scientists = as.character(scientist)
Survey_Responses$Student = scientists
Survey_Responses$Title_Role2 = if_else(Survey_Responses$Student=="TRUE", "Scientist", Survey_Responses$Title_Role)
# Now we'll cluster Land and Program Manager 
manager = grepl("Manager", Survey_Responses$Title_Role)
managers = as.character(manager)
Survey_Responses$Manager = managers
Survey_Responses$Title_Role3 = if_else(Survey_Responses$Manager=="TRUE", "Land/Program Manager", Survey_Responses$Title_Role2)
# Now we'll cluster Policy Experts
policy = grepl("Policy", Survey_Responses$Title_Role)
policys = as.character(policy)
Survey_Responses$Policy = policys
Survey_Responses$Title_Role4 = if_else(Survey_Responses$Policy=="TRUE", "Policy Expert", Survey_Responses$Title_Role3)

# Now lets see if we can make it into only 4 categories by putting everything else into an other category.
final = grepl("Land|Poli|Scie", Survey_Responses$Title_Role4)
Final = as.character(final)
Survey_Responses$Final = Final
Survey_Responses$Title_Role5 = if_else(Survey_Responses$Final=="TRUE", Survey_Responses$Title_Role4, "Other")

# Let's see how it looks now!
ggplot(data = Survey_Responses, aes(Title_Role5)) +
  geom_bar()
table(Survey_Responses$Title_Role5)


2. # Which best describes the spatial scale of your work?
      # This question does not have anything too tricky to deal with, so it will 
      # simply be plotted.
ggplot(data = Survey_Responses, aes(Spatial_Scale)) + 
  geom_bar()
table(Survey_Responses$Spatial_Scale)


3. # Where are you in your career?
ggplot(data = Survey_Responses, aes(Career_milestone)) + 
  geom_bar()
table(Survey_Responses$Career_milestone)


4. # I primaril work...
ggplot(data = Survey_Responses, aes(Work_location)) +  
  geom_bar()
table(Survey_Responses$Work_location)


*************************************** Section 2 Questions **********************************

1. # What type of coastal wetland carbon data would you like to see synthesized 
   # and publically available?
      # This question is simply a text field and will have almost entirely unique
      # answers. Because of this, try to find common words mentioned frequently such
      # as "flux", "stock", "burial" and create some sort of graphic to display
      # these interests. A word cloud is a good idea for instance.

2. # What is your preferred way of accessing data?
      # Similar to section 1 question 1, this questions has 5 possible answers,
      # with the last being a text field under  "Other". All answers should be coered into
      # one of the 5 fields for simplicity sake.

3. # Do you have data you would like to make publicly available?
      # This question again has 4 possible answers and a text field for the last answer 
      # choice. However, allof the answers in other are basically maybe... so we'll
      # just coerce all answer choices into yes, no, or maybe.


************************************** Section 3 Questions ***********************************

1. # Is there any support the network can give you to help with the process of 
   # making your data publicly available?  
      # There are 6 answer choices and they just need to be coded or renamed to 
      # fit on a graph more easily.


************************************** Section 4 Questions ***********************************

1. # What kind of data are you interested in submitting?
      # Again, try to find common words and make something like a word cloud.

2. # What is your motivation for archiving your data?
      # All answers need to be coerced into one of the 5 answer choices, with all entries
      # not fitting into the irst 4 classified as "Other". As an added bonus, we can make
      # a word cloud (or other creative representation) from all of the other choices
      # to see if there are any good ideas that weren't listed.


************************************* Section 5 Questions ************************************

1. # What type of training would improve your capacity as a scientist / 
   # practitioner / policy expert?
      # This can pretty much ust be plotted with a little cleaning up of the title fields.

2. # Would any of these proposed workshops be of interest to you?
      # Same as above, there are only 3 answer choices so this can just be plotted 
      # pretty easily.

3. # Do you have an idea for a collaborative workshop with the goal of a 
   # synthesis dataset, model, or and/or publication?
      # Try to identify common words in all of the responses and create something like a word cloud.

4. # What are some things that have worked about a collaborative workshops you have attended? 
      # Try to identify common words in all of the responses and create something like a word cloud.

5. # What can make a collaborative workshop ineffective, but can be avoided?
      # Try to identify common words in all of the responses and create something like a word cloud.


************************************* Section 6 Questions *************************************

1. # Where do you see the state of Coastal Wetland Carbon Research and Practice 
   # in 5 years (10 years)?
      # Maybe just pick out a few that are unique to display.

2. # Do you have any other feedback or concerns?
      # Coerce some of the long "no" answers into simply "No", and maybe find
      # one really good positive feedback, and one really good negative feedback.