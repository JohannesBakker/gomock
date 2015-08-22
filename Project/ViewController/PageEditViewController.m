//
//  PageViewController.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "PageEditViewController.h"
#import "ProjectPreviewViewController.h"
#import "Page.h"
#import "Link.h"
#import "CropViewLayer.h"

@interface PageEditViewController ()

@end

#define MIN_CROPVIEW_SIZE    30
#define EDGE_THRESHOLD  10

@implementation PageEditViewController
@synthesize currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPage:(Page *)page
{
    self = [super initWithNibName: @"PageEditViewController" bundle: nil];
    if (self) {
        self.currentPage = page;
        cropLayers = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    CGRect rtBounds = [[UIScreen mainScreen] applicationFrame];
    int height = rtBounds.size.height - 44 - 55;
    int width = height / 1.5f;
    int x = (rtBounds.size.width - width) / 2;
    int y = 70;
    imageView.frame = CGRectMake(x, y, width, height);
    imageView.image = self.currentPage.image;
    
    UIMenuItem* itemDelete = [[UIMenuItem alloc] initWithTitle: @"Delete" action: @selector(onDelete:)];
    UIMenuItem* itemLinkTo = [[UIMenuItem alloc] initWithTitle: @"Link To" action: @selector(onLinkTo:)];
    menuController = [UIMenuController sharedMenuController];
    menuController.menuItems = [NSArray arrayWithObjects: itemDelete, itemLinkTo, nil];
    [self initCropLayers];
}

- (void) initCropLayers
{
    for (Link* link in self.currentPage.links) {
        CropViewLayer* cropLayer = [[CropViewLayer alloc] initWithFrame: link.rectInPage];
        cropLayer.link = link;
        if (link.linkedPage != 0) {
            cropLayer.cropLayerType = WITH_LINK;
        }
        else
        {
            cropLayer.cropLayerType = WITHOUT_LINK;
        }
        [imageView addSubview: cropLayer];
        [cropLayers addObject: cropLayer];
    }
}

- (IBAction) onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onAddNewLink:(id)sender
{
    CropViewLayer* cropLayer = [[CropViewLayer alloc] initWithFrame: CGRectMake(50, 50, 100, 100)];
    cropLayer.isInEditing = YES;
    [imageView addSubview: cropLayer];
    Link* link = [Link new];
    link.currentPage = self.currentPage;
    link.rectInPage = cropLayer.frame;
    link.linkedPage = 0;
    cropLayer.link = link;
    [self.currentPage.links addObject: link];
    [cropLayers addObject: cropLayer];
}

- (IBAction) onPlayFromCurrentPage:(id)sender
{
    ProjectPreviewViewController* pController = [[ProjectPreviewViewController alloc] initWithPage: self.currentPage];
    [self presentViewController: pController animated: YES completion: nil];
}

- (eRectPoint) checkPointInCropView: (CropViewLayer*) cropView point: (CGPoint) point
{
    if(point.x < 0 || point.y < 0 || point.x > imageView.bounds.size.width || point.y > imageView.bounds.size.height)
    {
        return NoPoint;
    }
    
    _lastMovePoint = point;
    
    eRectPoint retPoint = NoPoint;
    
    CGRect rtCropView = cropView.frame;
    if(((point.x - EDGE_THRESHOLD) <= rtCropView.origin.x) &&
       ((point.x + EDGE_THRESHOLD) >= rtCropView.origin.x))
    {
        if(((point.y - EDGE_THRESHOLD) <= rtCropView.origin.y) &&
           ((point.y + EDGE_THRESHOLD) >= rtCropView.origin.y))
            retPoint = LeftTop;
        else if ((point.y - EDGE_THRESHOLD) <= (rtCropView.origin.y + rtCropView.size.height) &&
                 (point.y + EDGE_THRESHOLD) >= (rtCropView.origin.y + rtCropView.size.height))
            retPoint = LeftBottom;
        else
            retPoint = NoPoint;
    }
    else if(((point.x - EDGE_THRESHOLD) <= (rtCropView.origin.x + rtCropView.size.width)) &&
            ((point.x + EDGE_THRESHOLD) >= (rtCropView.origin.x + rtCropView.size.width)))
    {
        if(((point.y - EDGE_THRESHOLD) <= rtCropView.origin.y) &&
           ((point.y + EDGE_THRESHOLD) >= rtCropView.origin.y))
            retPoint = RightTop;
        else if ((point.y - EDGE_THRESHOLD) <= (rtCropView.origin.y + rtCropView.size.height) &&
                 (point.y + EDGE_THRESHOLD) >= (rtCropView.origin.y + rtCropView.size.height))
            retPoint = RightBottom;
        else
            retPoint = NoPoint;
    }
    else if ((point.x > rtCropView.origin.x) && (point.x < (rtCropView.origin.x + rtCropView.size.width)) &&
             (point.y > rtCropView.origin.y) && (point.y < (rtCropView.origin.y + rtCropView.size.height)))
    {
        retPoint = MoveCenter;
    }
    else
        retPoint = NoPoint;
    return retPoint;
}

#pragma mark TouchEvents
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint locationPoint = [[touches anyObject] locationInView: imageView];

    NSInteger currentMovePoint = NoPoint;
    for (CropViewLayer* cropView in cropLayers) {
        currentMovePoint = [self checkPointInCropView: cropView point: locationPoint];
        if ( currentMovePoint != NoPoint ) {
            if (_selectedCropView != nil) {
                _selectedCropView.isInEditing = NO;
            }
            
            _selectedCropView = cropView;
            _selectedCropView.isInEditing = YES;
            break;
        }
    }
    _movePoint = currentMovePoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView: imageView];
    if(_selectedCropView == nil || _movePoint == NoPoint)
    {
        _movePoint = NoPoint;
        return;
    }
    
    float x,y;
    CGRect rtCropView = _selectedCropView.frame;
    switch (_movePoint) {
        case LeftTop:
            if(((locationPoint.x + MIN_CROPVIEW_SIZE) >= (rtCropView.origin.x + rtCropView.size.width)) ||
               ((locationPoint.y + MIN_CROPVIEW_SIZE)>= (rtCropView.origin.y + rtCropView.size.height)))
                return;
            rtCropView = CGRectMake(locationPoint.x, locationPoint.y,
                                             rtCropView.size.width + (rtCropView.origin.x - locationPoint.x),
                                             rtCropView.size.height + (rtCropView.origin.y - locationPoint.y));
            break;
        case LeftBottom:
            if(((locationPoint.x + MIN_CROPVIEW_SIZE) >= (rtCropView.origin.x + rtCropView.size.width)) ||
               ((locationPoint.y - rtCropView.origin.y) <= MIN_CROPVIEW_SIZE))
                return;
            rtCropView = CGRectMake(locationPoint.x, rtCropView.origin.y,
                                             rtCropView.size.width + (rtCropView.origin.x - locationPoint.x),
                                             locationPoint.y - rtCropView.origin.y);
            break;
        case RightTop:
            if(((locationPoint.x - rtCropView.origin.x) <= MIN_CROPVIEW_SIZE) ||
               ((locationPoint.y + MIN_CROPVIEW_SIZE)>= (rtCropView.origin.y + rtCropView.size.height)))
                return;
            rtCropView = CGRectMake(rtCropView.origin.x, locationPoint.y,
                                             locationPoint.x - rtCropView.origin.x,
                                             rtCropView.size.height + (rtCropView.origin.y - locationPoint.y));
            break;
        case RightBottom:
            if(((locationPoint.x - rtCropView.origin.x) <= MIN_CROPVIEW_SIZE) ||
               ((locationPoint.y - rtCropView.origin.y) <= MIN_CROPVIEW_SIZE))
                return;
            rtCropView = CGRectMake(rtCropView.origin.x, rtCropView.origin.y,
                                             locationPoint.x - rtCropView.origin.x,
                                             locationPoint.y - rtCropView.origin.y);
            break;
        case MoveCenter:
            x = _lastMovePoint.x - locationPoint.x;
            y = _lastMovePoint.y - locationPoint.y;
            if(((rtCropView.origin.x - x) > 0) && ((rtCropView.origin.x + rtCropView.size.width - x) <
                                                          imageView.bounds.size.width) &&
               ((rtCropView.origin.y - y) > 0) && ((rtCropView.origin.y + rtCropView.size.height - y) < imageView.bounds.size.height))
            {
                rtCropView = CGRectMake(rtCropView.origin.x - x, rtCropView.origin.y - y, rtCropView.size.width, rtCropView.size.height);
            }
            _lastMovePoint = locationPoint;
            break;
        default: //NO Point
            return;
            break;
    }
    _selectedCropView.frame = rtCropView;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_movePoint == NoPoint) {
        if (_selectedCropView != nil) {
            _selectedCropView.isInEditing = NO;
        }
        _selectedCropView = nil;
        [menuController setMenuVisible: NO animated: YES];
    }
    else
    {
        [self becomeFirstResponder];
        if (_selectedCropView != nil) {
            Link* link = _selectedCropView.link;
            link.rectInPage = _selectedCropView.frame;
            [menuController setTargetRect: _selectedCropView.frame inView: imageView];
            [menuController setMenuVisible: YES animated: YES];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded: touches withEvent: event];
}

#pragma mark MenuController
- (void) onDelete: (id) sender
{
    if (_selectedCropView == nil) {
        return;
    }
    
    [self.currentPage.links removeObject: _selectedCropView.link];
    [cropLayers removeObject: _selectedCropView];
    [_selectedCropView removeFromSuperview];
}

- (void) onLinkTo: (id) sender
{
    PageListViewController* pController = [[PageListViewController alloc] initWithProject: self.currentPage.project link: _selectedCropView.link];
    pController.delegate = self;
    [self.navigationController pushViewController: pController animated: YES];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if ( action == @selector( onDelete: ) )
    {
        return YES; // logic here for context menu show/hide
    }
    
    if ( action == @selector( onLinkTo: ) )
    {
        return YES;  // logic here for context menu show/hide
    }
    return [super canPerformAction: action withSender: sender];
}

#pragma mark PageListViewControllerDelegate
- (void) pageSelected:(id)selectedPage
{
    if (_selectedCropView) {
        Link* link = _selectedCropView.link;
        link.linkedPage = ((Page*)selectedPage).index;
        _selectedCropView.cropLayerType = WITH_LINK;
    }
}

@end

