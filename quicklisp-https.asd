#|
  This file is a part of quicklisp-https project.
|#

(in-package :cl-user)
(defpackage quicklisp-https-asd
  (:use :cl :asdf))
(in-package :quicklisp-https-asd)

(defsystem quicklisp-https
  :version "0.1"
  :author "SANO Masatoshi"
  :license "MIT"
  :depends-on (:dexador)
  :components ((:module "src"
                :components
                ((:file "quicklisp-https"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op quicklisp-https-test))))
