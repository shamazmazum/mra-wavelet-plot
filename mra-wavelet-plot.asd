(defsystem :mra-wavelet-plot
  :name :mra-wavelet-plot
  :version "0.1"
  :author "Vasily Postnicov <shamaz.mazum@gmail.com>"
  :license "2-clause BSD"
  :description "Plot MRA-based wavelets (scaling function and mother wavelet)
with given coefficients of the dilation equation"
  :components ((:file "package")
	       (:file "mra-wavelet-plot" :depends-on ("package"))))
