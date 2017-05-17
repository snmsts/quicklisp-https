(in-package :asdf-user)

(defsystem quicklisp-https
  :version "0.1"
  :author "SANO Masatoshi"
  :license "MIT"
  :depends-on (:dexador)
  :components ((:module "src"
                :components
                ((:file "quicklisp-https"))))
  :description "Https support patch for quicklisp."
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
          seq))))
