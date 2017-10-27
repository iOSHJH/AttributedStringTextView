//
//  AttributedStringTextVC.m
//  AttributedStringTextView
//
//  Created by 黄俊煌 on 2017/8/14.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "AttributedStringTextVC.h"

@interface AttributedStringTextVC ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@property (nonatomic, assign) BOOL isClear;

/** 粗体*/
@property (nonatomic, assign) BOOL isBold;
/** 斜体*/
@property (nonatomic, assign) BOOL isItalics;
/** H1*/
@property (nonatomic, assign) BOOL isH1;


@end

/*
 <div class="test"></div>
 <!-- This is an HTML comment -->
 <p>This is a test of the <strong>ZSSRichTextEditor</strong> by <a title="Zed Said" href="http://www.zedsaid.com">Zed Said Studio</a>
 <img src="http://120.25.95.75:8080/imgfile/uploadFiles/uploadImgs\/html/img/20170622/1498123794135065031.jpeg" title="1498123794135065031.jpeg" alt="641.jpeg"/>
 </p>
 */

@implementation AttributedStringTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"export" style:UIBarButtonItemStylePlain target:self action:@selector(export)];
    
    [self.view addSubview:self.textView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fuwenben" ofType:@"txt"];
    ;
    NSString *content = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
    NSData *data = [content dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.textView.attributedText = attributedString;
    self.attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
}

- (void)export {
    //    @{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType}
    NSData *data = [self.attributedString dataFromRange:NSMakeRange(0, self.attributedString.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} error:nil];
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"html = %@",html);

    NSRange srcStartRange = [html rangeOfString:@"<img src=\"file:///"];
    if (srcStartRange.location == NSNotFound || srcStartRange.length == 0) {
        return;
    }
    //                NSUInteger location = srcStartRange.location + srcStartRange.length;
    //                NSUInteger length = htmlStr.length - location;
    //                NSRange srcEndRange = [htmlStr rangeOfString:@"alt" options:NSAnchoredSearch range:NSMakeRange(srcStartRange.location + srcStartRange.length, length)];
    NSRange srcEndRange = [html rangeOfString:@".png\">"];
    if (srcEndRange.location == NSNotFound || srcEndRange.length == 0) {
        return;
    }
    
    // model.path
    NSString *temp = [NSString stringWithFormat:@"http://120.25.95.75:8080/imgfile/uploadFiles/uploadImgs/html/img/20170622/1498123794135065031.jpeg\"/"];
    NSUInteger location = srcStartRange.location+10;
    NSUInteger length = srcEndRange.location - srcStartRange.location - 10 + 5;
    NSString *htmlStr = [html stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:temp];
    NSLog(@"htmlStr = %@",htmlStr);
    
    
    //        NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    //        NSString *pathFile = [path stringByAppendingPathComponent:@"text"];  //要保存的文件名
    //        [data writeToFile:pathFile atomically:YES];  //写入文件
    
//    NSMutableArray *textAttachments = [NSMutableArray array]; // 富文本中的所有附件
//    [self.attributedString enumerateAttributesInRange:NSMakeRange(0, self.attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//        if ([attrs.allValues.firstObject isKindOfClass:[NSTextAttachment class]]) {
//            [textAttachments addObject:attrs.allValues.firstObject];
//        }
//    }];
//    NSLog(@"textAttachments = %@",textAttachments);
    /*
     textAttachments = (
     "<NSTextAttachment: 0x1740bc260>",
     "<NSTextAttachment: 0x1740b73a0>"
     )
     */
    
//    [self.attributedString enumerateAttribute:<#(nonnull NSString *)#> inRange:<#(NSRange)#> options:<#(NSAttributedStringEnumerationOptions)#> usingBlock:<#^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop)block#>];
}

- (UIView *)createInputAccessoryView {
    // 键盘工具栏
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(item1Action)];
    UIBarButtonItem *th1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_b"] style:UIBarButtonItemStylePlain target:self action:@selector(item2Action:)];
    UIBarButtonItem *th2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_i"] style:UIBarButtonItemStylePlain target:self action:@selector(item3Action:)];
    UIBarButtonItem *th3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_h1"] style:UIBarButtonItemStylePlain target:self action:@selector(item4Action:)];
    UIBarButtonItem *th4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(item5Action:)];
    UIBarButtonItem *th5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_reset"] style:UIBarButtonItemStylePlain target:self action:@selector(item6Action:)];
    
    UIToolbar *tool = [UIToolbar new];
    [tool sizeToFit];
    [tool setItems:@[item1,th1, item2, th2, item3, th3, item4, th4, item5, th5, item6]];
    return tool;
}

- (void)item1Action {
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pick.sourceType=UIImagePickerControllerSourceTypeCamera;//设置 pick 的类型为相机
        pick.delegate=self;
        [self presentViewController:pick animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        //pick.allowsEditing = YES;//设置是否可以编辑相片涂鸦
        pick.delegate=self;
        [self presentViewController:pick animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)item2Action:(UIBarButtonItem *)item {
    if (self.isBold) {
        item.tintColor = nil;
    }else { // 选中
        item.tintColor = [UIColor redColor];
    }
    self.isBold = !self.isBold;
}

- (void)item3Action:(UIBarButtonItem *)item {
    if (self.isItalics) {
        item.tintColor = nil;
    }else { // 选中
        item.tintColor = [UIColor redColor];
    }
    self.isItalics = !self.isItalics;
}

- (void)item4Action:(UIBarButtonItem *)item {
    if (self.isH1) {
        item.tintColor = nil;
    }else { // 选中
        item.tintColor = [UIColor redColor];
    }
    self.isH1 = !self.isH1;
}

- (void)item5Action:(UIBarButtonItem *)item {
    NSUndoManager *undoManager = [self.textView undoManager];
    [undoManager undo];
}

- (void)item6Action:(UIBarButtonItem *)item {
    NSUndoManager *undoManager = [self.textView undoManager];
    [undoManager redo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attachment.image=image;
    attachment.bounds=CGRectMake(0, -10, 200, 200);
    NSAttributedString *attributedString=[NSAttributedString attributedStringWithAttachment:attachment];
    [self.attributedString appendAttributedString:attributedString];
    self.textView.attributedText = self.attributedString;
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.isClear) {
        self.attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        return;
    }
    textView.attributedText = self.attributedString;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length < 1) {
        self.isClear = YES;
        return YES;
    }
    self.isClear = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.isBold) {
        [dict setValue:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKey:NSFontAttributeName];
    }else {
        [dict setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    }
    if (self.isItalics) {
        [dict setValue:@(0.5) forKey:NSObliquenessAttributeName];
    }
    if (self.isH1) {
        if (self.isBold) {
            [dict setValue:[UIFont fontWithName:@"Helvetica-Bold" size:20] forKey:NSFontAttributeName];
        }else {
            [dict setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
        }
    }
    
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:text
                                                              attributes:dict];
    [self.attributedString appendAttributedString:attr];
    
    return YES;
}

#pragma mark - get

- (UITextView *)textView {
    if (_textView) return _textView;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 70, 300, 250)];
//    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.delegate = self;
    _textView.inputAccessoryView = [self createInputAccessoryView];
    return _textView;
}

@end







