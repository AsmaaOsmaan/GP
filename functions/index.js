const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
exports.onCreateActivityLogItem = functions.firestore
//5arJBmgyMNlJgLKyvldS->should be childId
//1->should be parentid
.document("/ActivtyLog/{parentId}/ActivtyLogitem/{activtyId}")
  .onCreate(async (snapshot, context) => {
    console.log("Activity Log Item Created", snapshot.data());
    console.log("context params is", context.params);
    // 1) Get user connected to the feed
            //should be const parentid = context.params.parentId;
   const userId = context.params.parentId;
 console.log("userId Created",userId);
    //const userRef = admin.firestore().doc('User/{userId}');
  const userRef = admin.firestore().collection('User'). doc(userId);
  console.log("userRef without get",userRef);
     console.log("userRef",userRef.get());
    const doc = await userRef.get();
    // 2) Once we have user, check if they have a notification token; send notification, if they have a token
   const androidNotificationToken = doc.data().androidNotificationToken;
    const createdActivityLogItem = snapshot.data();
    if (androidNotificationToken) {
      sendNotification(androidNotificationToken, createdActivityLogItem);
    } else {
      console.log("No token for user, cannot send notification");
    }
    function sendNotification(androidNotificationToken, activityLogitem) {
      let body;
      // 3) switch body value based off of notification type
      switch (activityLogitem.type) {
        case "comment":
          body = `${activityLogitem.username} Commented On Post: ${activityLogitem.commentData }`;
          break;
        case "like":
          body =` ${activityLogitem.username} liked on post`;
          break;
        case "follow":
          body = `${activityLogitem.username} started follow for some one`;
          break;
         case "post":
            body = `${activityLogitem.username} Shear New Post`;
            break;
        case "createPage":
            body = `${activityLogitem.username} Create New Page: ${activityLogitem.pageName }`;
            break;
        case "likePage":
           body = `${activityLogitem.username} Liked On Page ${activityLogitem.pageName}`;
           break;
        case "joinGroup":
            body = `${activityLogitem.username} Join To New Group`;
            break;
        case "sendRequest":
          body = `${activityLogitem.username}  Send Friend Request`;
          break;
       case "followPage":
          body = `${activityLogitem.username} started follow for ${activityLogitem.pageName }`;
          break;
       case "createGroup":
          body = `${activityLogitem.username} Created  Group: ${activityLogitem.groupName }`;
          break;
        default:
          break;
      }
      // 4) Create message for push notification
      const message = {
        notification: { body,
          title: 'New Notification',


          },
        token: androidNotificationToken,
        data: { recipient: userId,click_action: 'FLUTTER_NOTIFICATION_CLICK' }
      };
      // 5) Send message with admin.messaging()
      admin
        .messaging()
        .send(message)
        .then(response => {
          // Response is a message ID string
          console.log("Successfully sent message", response);
        })
        .catch(error => {
          console.log("Error sending message", error);
        });
    }
  });
  //new function/////////////////////////////////

  exports.onCreateChildNotificationItem = functions.firestore
  //5arJBmgyMNlJgLKyvldS->should be childId
  //1->should be parentid
  .document("/Notification/{OwnerId}/Notificationitem/{NotificationId}")
    .onCreate(async (snapshot, context) => {
      console.log("Notification Item Created", snapshot.data());
      console.log("context params is", context.params);
      // 1) Get user connected to the feed
     //should be const parentid = context.params.parentId;
     const userId = context.params.OwnerId;

       // const userId='jeffd23';
   console.log("userId Created",userId);
      //const userRef = admin.firestore().doc('User/{userId}');
    const userRef = admin.firestore().collection('User'). doc(userId);
    console.log("userRef without get",userRef);
       console.log("userRef",userRef.get());
      const doc = await userRef.get();

      // 2) Once we have user, check if they have a notification token; send notification, if they have a token

     const androidNotificationToken = doc.data().androidNotificationToken;
      const createdActivityLogItem = snapshot.data();
      if (androidNotificationToken) {
        sendNotification(androidNotificationToken, createdActivityLogItem);
      } else {
        console.log("No token for user, cannot send notification");
      }
      function sendNotification(androidNotificationToken, activityLogitem) {
        let body;
        // 3) switch body value based off of notification type
        switch (activityLogitem.type) {
          case "comment":
            body = ` ${activityLogitem.username} Commented On your Post:${activityLogitem.commentData}` ;
            break;
          case "like":
            body =` ${activityLogitem.username} liked on  your post`;
            break;

          default:
            break;}

        // 4) Create message for push notification
        const message = {
          notification: { body,
           title: 'New Notification',
 },
          token: androidNotificationToken,
          data: { recipient: userId ,click_action: 'FLUTTER_NOTIFICATION_CLICK'}
        };
        // 5) Send message with admin.messaging()
        admin
          .messaging()
          .send(message)
          .then(response => {
            // Response is a message ID string
            console.log("Successfully sent message", response);
          })
          .catch(error => {
            console.log("Error sending message", error);
          });
      }
    });