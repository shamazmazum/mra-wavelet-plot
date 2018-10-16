mra-wavelet-plot
---------------

**mra-wavelet-plot** helps to plot multiresolution analysis-based wavelets (scaling
funtions and mother wavelets). All you need are the coefficients of dilation equation. The
output is two plain text files understandable by plotter program, e.g. gnuplot. The
package provides examples for D4, D6 and second order coiflet wavelets.

Example:

~~~~~~~~{lisp}
;; Output D4 wavelet into home directory
(mra-wavelet-plot:plot-wavelet "d4" mra-wavelet-plot:*d4-wavelet* 10 :directory "~/")
;; Type this in gnuplot: plot "d4-scaling.dat" with lines, "d4-wavelet.dat" with lines
~~~~~~~~
