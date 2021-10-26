/*
 Josiah - Oct 29, 2020
 Cache
 prefetch the data
 */

//import Foundation

/*
 
 
 // Limit memory cache to hold 150 images at most.
 //cache.memoryStorage.config.countLimit = 150
 
 // Disk image never expires.
 cache.diskStorage.config.expiration = .never
 
 
 
 //Downloading an image manually
 let downloader = ImageDownloader.default
 downloader.downloadImage(with: url) { result in
     switch result {
     case .success(let value):
         print(value.image)
     case .failure(let error):
         print(error)
     }
 }
 
 
 //
 //Prefetch

 //You could prefetch some images and cache them before you display them on the screen. This is useful when you know a list of image resources you //know they would probably be shown later.
 let urls = ["https://example.com/image1.jpg", "https://example.com/image2.jpg"]
            .map { URL(string: $0)! }
 let prefetcher = ImagePrefetcher(urls: urls) {
     skippedResources, failedResources, completedResources in
     print("These resources are prefetched: \(completedResources)")
 }
 prefetcher.start()

 
 // Later when you need to display these images:
 imageView.kf.setImage(with: urls[0])
 anotherImageView.kf.setImage(with: urls[1])
 
 //Load gif
 let imageView: UIImageView = ...
 imageView.kf.setImage(with: URL(string: "your_animated_gif_image_url")!)
 */
