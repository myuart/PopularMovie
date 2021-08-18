# PopularMovie
A mobile app retrieves the popular movies from The Movie Database.
This app uses MVC architecture.
No third-party libries are needed for running the app.
Swift native URLSession is used to perform API calls. 
A helper Extensions.swift file is created to handle thumbnail image cache and retrieval.
A special algorithm is implemented to handle additional movie data downloading when the user scrolls to the end of the table. As long as the API can return more data, the app can display more movies.
The movie details page displays thumbnail, title, popularity score, release year and overview. However, runtime and link to the movie homepage are not available in the API response.
The app was developed in the lastest Xcode on Big Sur macOS and also tested in Xcode 12.4 on Catalina. When running the app on Big Sur please choose iOS 14.5 for Deployment.
