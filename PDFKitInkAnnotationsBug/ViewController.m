//
//  ViewController.m
//  PDFKitInkAnnotationsBug
//
//  Created by Korobov Dmitry on 25.06.2018.
//  Copyright © 2018 Dmitry Korobov. All rights reserved.
//

#import "ViewController.h"
#import <PDFKit/PDFKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//Step 1: Loading PDF and check that first page contains inkAnnotation with not empty bezier curves
	NSString *pathToPDF = [NSBundle.mainBundle pathForResource:@"sample" ofType:@".pdf"];
	NSURL *urlToPDF = [[NSURL alloc] initFileURLWithPath:pathToPDF];
	PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:urlToPDF];
	PDFPage *pdfFirstPage = [pdfDocument pageAtIndex:0];
	PDFAnnotation *pdfInkAnnotation = pdfFirstPage.annotations[0];
	
	NSArray *bezierCurvesFromPaths = pdfInkAnnotation.paths;
	NSLog(@"Number of bezier curves (from .paths): %li", bezierCurvesFromPaths.count);
	NSArray *bezierCurvesFromDictionary = [pdfInkAnnotation valueForAnnotationKey:PDFAnnotationKeyInklist];
	NSLog(@"Number of bezier curves (from dictionary): %li", bezierCurvesFromDictionary.count);
	//Everything is fine, we got an array of bezier curves in two ways
	
	
	//Step 2: Save the same PDF in the directory documents
	NSURL *urlToNewPDF = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
	NSString *pathToNewPDF = [urlToNewPDF.path stringByAppendingPathComponent:@"newSample.pdf"];
	BOOL check = [pdfDocument writeToFile:pathToNewPDF];
	NSLog(@"Save PDF success: %@", check ? @"YES" : @"NO");
	
	
	//Step 3: Loading new PDF from document directory and check that first page contains inkAnnotation with not empty bezier curves
	PDFDocument *newPDFDocument = [[PDFDocument alloc] initWithURL:[urlToNewPDF URLByAppendingPathComponent:@"newSample.pdf"]];
	PDFPage *newPdfFirstPage = [newPDFDocument pageAtIndex:0];
	PDFAnnotation *newPdfInkAnnotation = newPdfFirstPage.annotations[0];
	
	NSArray *newBezierCurvesFromPaths = newPdfInkAnnotation.paths;
	NSLog(@"Number of bezier curves (from .paths): %li", newBezierCurvesFromPaths.count);
	NSArray *newBezierCurvesFromDictionary = [newPdfInkAnnotation valueForAnnotationKey:PDFAnnotationKeyInklist];
	NSLog(@"Number of bezier curves (from dictionary): %li", newBezierCurvesFromDictionary.count);
	//After reload the document, the bezier curves are not filled in. They are not in the "paths" property, and not in annotation dictionary by PDFAnnotationKeyInklist key.
	
	//This bug appears for any ways to save the PDF into a file. Convert PDFDocument to NSData gives the same result
}

@end
