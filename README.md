# Requirements.

- We have attached
  screenshot [Mobile.png](https://objectstorage.ap-mumbai-1.oraclecloud.com/n/bmdbzt55yxqo/b/static-dev/o/temp%2FMobile.png)
  , where we want to have a Flutter Widget which could have anything around rectangle annotation.

### Our roadmap

- Once that is achieved via flutterSDK updation, we will go for making the Flutter widget more fancy
  like in
  the [web](https://objectstorage.ap-mumbai-1.oraclecloud.com/n/bmdbzt55yxqo/b/static-dev/o/temp%2Fweb-screen-recording.mov)
  .
- We will not allowing or partially allowing the users to mark/annote something so customisation of
  annotation options is also needed in flutterSDK.
- The metadata of annotations will be media contents(image/PDF/video,etc). While loading
  annotations, we will also load its metadata where user can navigate to different
  medias. [#ref](https://objectstorage.ap-mumbai-1.oraclecloud.com/n/bmdbzt55yxqo/b/static-dev/o/temp%2Fweb-screen-recording.mov)
  .

### Note

- We only consider pspdfkit/shape/rectangle to have metadata with each annotation which is being
  created by
  our [publishers](https://objectstorage.ap-mumbai-1.oraclecloud.com/n/bmdbzt55yxqo/b/static-dev/o/temp%2Fweb-screen-recording.mov)
  for now. It would be better if we get metadata and manipulate those metadata in Flutter custom
  build widget as we want.