\version "2.24.3"

%%%%%%% CUSTOMIZE numbers here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

staff_size = 20 
%%%% good size is ca. 20.  24 is reasonably big, 30 is unreasonably big

orientation = #'portrait 
%%%% or uncomment the following line:
orientation = #'landscape

number_staves = 12 
staves_per_system = 3
%%%% i.e., number of systems will be number_staves/staves_per_system, rounded to nearest integer



%%%%%%%%%%%%%%%%% uncomment these lines for "A4" size
%{
%\paper {
%  #(set-paper-size "a4" orientation)
%  ragged-last-bottom = ##f
%  print-page-number = ##f
%% line-width = 180
%%%%% line-width might interfere with landscape mode
%  left-margin = 15
%  bottom-margin = 10
%  top-margin = 10
%}
%

%%%%%%%%%%%%%%%%% uncomment these lines for "letter" size
\paper {
  #(set-paper-size "letter" orientation)
  ragged-last-bottom = ##f
  print-page-number = ##f
  % line-width = 7.5\in 
  %%%% line-width might interfere with landscape mode
  left-margin = 0.5\in
  bottom-margin = 1\in
  top-margin = 1\in
}


%%%% IGNORE THE REST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% TODO: Make spacing between staves within a system, and between systems, somehow automatically/usefully interdependent with staff size, and possibly paper orientation?
%%%% TODO: Simplify paper options

#(set-global-staff-size staff_size)

\header {
    tagline = ##f
}




%% make list of length n with all elements === el
%% eg. (nlist el 5) -> (el, el, el, el, el)
#(define (nlist el n)
   (if (zero? n)
     `()
     (cons el (nlist el (- n 1)))))
    


%% make the simultaneousMusic that goes into the PianoStaff: 
%% 
makeEmptyStaves =
#(define-music-function (number_staves staves_per_system) (index? index?) 
     (let* ((actual_number_staves (round-quotient number_staves staves_per_system))
           (empty #{ \new Staff {\repeat unfold $actual_number_staves {s1 \break }}#}))
        (make-music
          'SimultaneousMusic
          'elements
          (nlist empty staves_per_system))))

\score {
  %%%% PianoStaff:
  %%%% gotta make a func of the "empty" such that it divides the 10 by 2, etc.
  \new PianoStaff \makeEmptyStaves \number_staves \staves_per_system
  \layout {
    indent = 0\in
    \context {
      \Staff
      \remove "Time_signature_engraver"
      \remove "Clef_engraver"
      \remove "Bar_engraver"
    }
    \context {
      \Score
      \remove "Bar_number_engraver"
      %%%% to remove the bar at system start:
      \remove "System_start_delimiter_engraver" 
    }
    \context {
      \PianoStaff
      %%%% to remove the brace:
      \remove "System_start_delimiter_engraver" 
    }
  }
}

