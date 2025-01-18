//
//  Profile.swift
//  Visera
//
//  Created by student-2 on 20/12/24.
//
import UIKit
struct ProfileData {
    var postImages: [UIImage]  // Post images for the "Post" section
    var collectionImages: [UIImage]  // Images for the "Collection" section
    
    init(postImages: [UIImage] = [], collectionImages: [UIImage] = []) {
        self.postImages = postImages
        self.collectionImages = collectionImages
    }
}
