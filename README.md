# PDFKitInkAnnotationBezierPathsBug
Empty Bezier Curves for Ink Annotation

Summary: 

When you save a PDF to a file in any way, the bezier curves are lost. On subsequent loading, the "path" of the PDFAnnotation class is empty, as is the empty value in the PDAnnotation properties dictionary by "PDFAnnotationKeyInklist". At the same time PDFView or Apple iBooks renders the annotation correctly, so this means that the points of the bezier curves persist, but when loading such documents, they do not "jump" to the high level facade class (PDFAnnotation.paths). They stay at a lower level, in the internal implementation of PDFKit.

Steps to Reproduce:

Take an external PDF with ink annotations (created in Adobe Acrobat Reader for example). Load it using PDFKit. Make sure that the curves of the beziers are present in "PDFAnnotation.paths". Overwrite the PDF into another file and load it again.

Expected Results:

"PDFAnnotation.paths" and "[PDFAnnotation valueForAnnotationKey:PDFAnnotationKeyInklist]" return an array of bezier curves.

Actual Results:

The return value is nil.

Version/Build:

iOS 11.0-11.4.1 (Fixed in iOS 12.0)

Configuration:

All simulators and devices.


Apple forum: https://forums.developer.apple.com/thread/90841

StackOverflow: https://stackoverflow.com/questions/48530408/pdfannotationsubtype-ink-not-saved-when-persisting-ios11-pdfkit/48589894#48589894
