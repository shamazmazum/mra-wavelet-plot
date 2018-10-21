(in-package :mra-wavelet-plot)

(defparameter *d4-wavelet* #(0.48296294 0.8365163 0.22414388 -0.12940952)
  "Daubechies D4 wavelet example")

(defparameter *d6-wavelet* #(0.157261 -0.190968 -0.834205
                             -0.491299 -0.030163 -0.024839)
  "Daubechies D6 wavelet example")

(defparameter *coiflet-2* #(-0.0156557 -0.0727326 0.3848648
                            0.8525720 0.3378977 -0.0727326)
  "Second order coiflet example")

(defvar *dc* nil
  "Coefficients of dilation equation")

(defparameter *format-string* "~d ~f~%"
  "Format string used for printing result to a file")

(defun larger-scale (array)
  "Generate the next ladder of wavelet function"
  (let ((alen (length array))
        (clen (length *dc*)))
    (let ((new-array (make-array (* alen 2) :initial-element 0)))
      (loop
         for idx from 0 by (/ alen (1- clen))
         for j below clen do
           (loop for i below alen do
                (incf (aref new-array (+ i idx))
                      (* (sqrt 2.0) (aref *dc* j) (aref array i)))))
      new-array)))

(defun make-ia (n)
  "Generate initial array for wavelet function"
  (let ((array (make-array n :initial-element 0.0)))
    (setf (aref array (floor n 2)) 1.0)
    array))

(defun gen-scaling-function (n &optional array)
  "Generate scaling function"
  (let ((array (if array array (make-ia (1- (length *dc*))))))
    (if (zerop n) array (gen-scaling-function (1- n) (larger-scale array)))))

(defun scaling->wavelet (coeff)
  (make-array (length coeff)
              :initial-contents
              (loop
                 for i from 1 by 1
                 for x across (reverse coeff) collect
                   (* (expt -1 i) x))))

(defun gen-wavelet-function (n)
  "Generate mother wavelet function"
  (let ((array (gen-scaling-function (1- n)))
        (*dc* (scaling->wavelet *dc*)))
    (larger-scale array)))

(defun array2file (filename array)
  "Write an array to a file in the format understood by plotter program."
  (with-open-file (stream
                   filename
                   :direction :output
                   :if-exists :supersede
                   :if-does-not-exist :create)
    (loop
       for i from 0 by 1
       for x across array do
         (format stream *format-string* i x))))

(defun plot-wavelet (name coeff n &key (type "dat") directory)
  "Plot scaling function and mother wavelet to files with names
 NAME-scaling.TYPE and NAME-wavelet.TYPE . `COEFF' is a vector with coefficients
 of dilation equation. `N' is how many dilations will happen."
  (declare (type string name type)
           (type vector coeff)
           (type (integer 0) n)
           (type (or null pathname string) directory))
  (let ((*dc* coeff)
        (scaling-name (make-pathname :name (format nil "~a-scaling" name)
                                     :type type))
        (wavelet-name (make-pathname :name (format nil "~a-wavelet" name)
                                     :type type)))
    (array2file (if directory (merge-pathnames directory scaling-name) scaling-name)
                (gen-scaling-function n))
    (array2file (if directory (merge-pathnames directory wavelet-name) wavelet-name)
                (gen-wavelet-function n)))
  t)
