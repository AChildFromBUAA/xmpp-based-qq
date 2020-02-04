# Instant messaging based on XMPP framework
 This is an instant messaging application based on XMPP framework in iOS plantform. I did it in 2017 but upload it in 2020 in order to save it somewhere(XD).
 ## 1. Install Openfire
 This is an English version from my [CSDN blog](https://blog.csdn.net/AchildFromBUAA/article/details/50975727), but I cannot login now due to phone verification. :( 

 First, download [Openfire](http://www.igniterealtime.org/downloads/index.jsp).

 Then, download [mysql](http://dev.mysql.com/downloads/mysql/).

After mysql installed, save your root password. Log in as root, and make a schema (ready for setting Openfire).

Open Openfire in your Preferences, and click "open admin console". Continue, Continue... Continue until database settings. Select the first in two options, and continue. In the first row, select mysql, and replace the first [] with your server name and the second [] with the name of the schema we created before in the tried tow. Add the username and password of your database. Set your password of admin in Openfire. Finish!
## 2. Functions
* sign in
* sign up
* edit profile (photo)
* view contacts
* add friends
* chat

## 3. About this application
XMPP framework is downloaded from [this repo](https://github.com/robbiehanson/XMPPFramework).
