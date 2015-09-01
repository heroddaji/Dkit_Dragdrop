
import UIKit

public protocol DKDraggableViewDelegate{
    func onDropedToTarget(sender: DKDraggableView, target: UIView)
}

public class DKDraggableView: UIImageView, UIGestureRecognizerDelegate {
    
    private var enableDragMovement = false
    private var draggingView :DKDraggableView?
    private var dropTarget : UIView?
    private var dropTargetIsEnlarge = false
    private var isLeavingAfterEnteredDropTarget = false
    private var isEnteredDropTarget = false

    public var delegate:DKDraggableViewDelegate?
    public var enableDragging = true {
        didSet{
            if enableDragging == true {
                self.userInteractionEnabled = true
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: "responseToLongPressGesture:")
                longPressGesture.delegate = self
                self.addGestureRecognizer(longPressGesture)
                
                let panGesture = UIPanGestureRecognizer(target: self, action: "responseToPanGesture:")
                self.addGestureRecognizer(panGesture)
                
            }else if(enableDragging == false){
                self.gestureRecognizers = []
            }
        }
    }
    
    
    
    //MAKR: make fake dragging View
    private func createFakeDragginView() {
        
        draggingView = DKDraggableView(frame: self.frame)
        draggingView?.userInteractionEnabled = true
        draggingView?.autoresizingMask = UIViewAutoresizing.None
        draggingView?.contentMode = UIViewContentMode.Center
        draggingView?.layer.cornerRadius = 5.0
        draggingView?.layer.borderWidth = 1.0
        draggingView?.clipsToBounds = true
        
        draggingView?.addSubview(UIImageView(image: scaledImageToSize(self.image!, newSize: self.bounds.size)))
        
        self.superview?.addSubview(draggingView!)
        
    }
    
    private func removeFakeDraggingView(){
        draggingView?.removeFromSuperview()
    }
    
    //MARK: touch handling
    func responseToLongPressGesture(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began {
           
            enableDragMovement = true
            createFakeDragginView()
            animateView(draggingView!, sender: sender, scale: 1.3, alpha: 0.6, duration: 0.3)
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            
            enableDragMovement = false
            removeFakeDraggingView()
            animateView(draggingView!, sender: sender, scale: 1.0, alpha: 1.0, duration: 0.3)
            if dropTarget != nil{
                animateView(dropTarget!, sender: sender, scale: 1.0, alpha: 1.0, duration: 0.3)
                if isEnteredDropTarget{
                    delegate?.onDropedToTarget(draggingView!,target: dropTarget!)
                }
            }
        }
    }
    
    
    func responseToPanGesture(sender: UIPanGestureRecognizer){
        if enableDragMovement{
            if sender.state == UIGestureRecognizerState.Began ||
                sender.state == UIGestureRecognizerState.Changed {
                    
                    let translation = sender.translationInView(draggingView!.superview!)
                    draggingView!.center = CGPointMake(draggingView!.center.x + translation.x, draggingView!.center.y + translation.y)
                    sender.setTranslation(CGPointZero, inView: draggingView!.superview)
                    
                    if dropTarget != nil{
                        checkIfEnterDropTarget(sender)
                        checkIfLeavingDropTarget(sender)
                        
                    }
            }
            if sender.state == UIGestureRecognizerState.Ended{
                
                
            }
        }
    }    
    
    //MARK: drop target
    public func setDropTarget(target: UIView){
        dropTarget = target
    }
    
    private func checkIfEnterDropTarget(sender:UIGestureRecognizer) -> Bool{
        let location = sender.locationInView(draggingView!.superview)
        if CGRectContainsPoint(dropTarget!.frame, location)
        {
            animateView(dropTarget!, sender: sender, scale: 1.5, alpha: 0.6, duration: 0.3)
            isEnteredDropTarget = true
        }
        else{
            if isEnteredDropTarget{
                isLeavingAfterEnteredDropTarget = true
            }
        }
        return isEnteredDropTarget
    }
    
    private func checkIfLeavingDropTarget(sender:UIGestureRecognizer){
        if isEnteredDropTarget && isLeavingAfterEnteredDropTarget{
            animateView(dropTarget!, sender: sender, scale: 1.0, alpha: 1.0, duration: 0.3)
            isEnteredDropTarget = false
            isLeavingAfterEnteredDropTarget = false
        }
        
    }
    
    //MARK: animation
    
    private func animateView(view:UIView, sender: UIGestureRecognizer, scale:CGFloat = 1.3, alpha:CGFloat = 0.5,duration:NSTimeInterval = 0.2){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        view.transform = CGAffineTransformMakeScale(scale, scale)
        view.alpha = alpha
        UIView.commitAnimations()
        
    }
    
    //MARK: delegate
    @objc public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func scaledImageToSize(image: UIImage, newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0 ,0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
