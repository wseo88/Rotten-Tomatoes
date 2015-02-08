## Rotten Tomatoes

This is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 10 hours

### Features

#### Required

- [X] User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for movies API.
- [X] User sees error message when there's a networking error: (http://i.imgur.com/N2XHP1y.png)
- [X] User can pull to refresh the movie list.

#### Optional

- [X] Add a tab bar for Box Office and DVD.
- [X] Add a search bar.
- [X] All images fade in.
- [X] For the large poster, load the low-res image first, switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.

### Walkthrough

![Video Walkthrough](rotten_tomato_walkthrough.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [SVProgressHUD](http://samvermette.com/199)