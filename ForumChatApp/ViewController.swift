//
//  ViewController.swift
//  ForumChatApp
//
//  Created by Shakti Pratap Singh on 05/06/17.
//  Copyright © 2017 Shakti Pratap Singh. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ViewController: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var messages = [JSQMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyScrollsToMostRecentMessage=true
        self.senderId="1"
        self.senderDisplayName="me"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text))
        messages.append(JSQMessage(senderId: "12", displayName: "raam", text: "This is a random test reply"))
        collectionView.reloadData()
        
    }
    override func didPressAccessoryButton(_ sender: UIButton!) {
            let picker = UIImagePickerController()
            picker.delegate = self
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
            } else {
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            }
        picker.allowsEditing=false
            present(picker, animated: true, completion:nil)
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let mediaItem = JSQPhotoMediaItem(image: image)
        messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: mediaItem))
        messages.append(JSQMessage(senderId: "12", displayName: "raam", text: "nice image, bot replied"))
        self.collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        self.scrollToBottom(animated: true)
        return cell
    }
   override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubble = JSQMessagesBubbleImageFactory()
        if messages[indexPath.row].senderId==self.senderId{
        return bubble?.outgoingMessagesBubbleImage(with: UIColor.green)
        }
        else{
         return bubble?.incomingMessagesBubbleImage(with: UIColor.gray)
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.row]
        if message.isMediaMessage{
            let media = message.media as! JSQPhotoMediaItem
            let destinationVc = self.storyboard?.instantiateViewController(withIdentifier: Constants.imageVcIdentifier) as! ImageViewController
            destinationVc.image=media.image
            present(destinationVc, animated: true, completion: nil)
        }
    }
}

