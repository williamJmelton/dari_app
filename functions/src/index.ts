import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

exports.onNewsAdded = functions.firestore
  .document('news/{wildcard}')
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic(
      'news',
      {
        notification: {
          title: snapshot.data().title,
          body: snapshot.data().description,
          clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        }
      })
  })