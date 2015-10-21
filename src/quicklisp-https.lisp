(in-package :cl-user)
(defpackage quicklisp-https
  (:use :cl))
(in-package :quicklisp-https)

(defgeneric fetch (type params)
  (:documentation ""))

(defvar *fetch-method* nil)

(setf (fdefinition (find-symbol (string :fetch) :ql-http))
      (lambda
          (url file &key (follow-redirects t) quietly (maximum-redirects 10))
        "Request URL and write the body of the response to FILE."
        (let ((result (fetch *fetch-method* (list :url url
                                                  :file file
                                                  :follow-redirects follow-redirects
                                                  :quietly quietly
                                                  :maximum-redirects maximum-redirects))))
          (values
           (make-instance 'ql-http::header
                          :status (if result 200 500))
           (when result (probe-file file))))))

(defmethod fetch ((type (eql nil)) param)
  (cond ((and (find-package :dexador)
              (not (find :dexador-no-ssl *features*))
              (fetch :dexador param)))
        ((find :ros.init *features*) (fetch :roswell param))
        (t (fetch :quicklisp param))))

(defmethod fetch ((type (eql :roswell)) param)
  (if (find :ros.init *features*)
      (funcall (find-symbol (find-symbol (string '#:roswell) '#:ros))
               `("roswell-internal-use" "download"
                                        ,(ql-http::urlstring
                                          (ql-http:url (getf param :url)))
                                        ,(getf param :file) "2")
               (if (find :abcl *features*)
                   :interactive
                   *standard-output*))
      (error "fail to find roswell component")))

(defmethod fetch ((type (eql :dexador)) param)
  (multiple-value-bind (i code)
      (dex:get (ql-http::urlstring
                (ql-http:url (getf param :url)))
               :force-binary t
               :want-stream t)
    (if (<= 500 code)
        nil
        (with-open-file (o (getf param :file)
                           :direction :output
                           :element-type '(unsigned-byte 8)
                           :if-exists :rename-and-delete)
          (uiop:copy-stream-to-stream i o :element-type '(unsigned-byte 8))
          t))))
