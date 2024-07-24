# piecenorms 1.0.0

-   Initial CRAN submission.

# piecenorms 1.1.0

Changes in version 1.1.0

New features

-   New normalisr() R6 class that
    -   Classifies the distribution of user data
    -   Recommends a piecewise normalisation technique
    -   Calculates normalised data and the percentiles
    -   Provides plot(), print(), hist() and as.data.frame() methods to allow comparison of original and normalised data.
    -   Provides the user the ability to set Manual normalisation breaks via SetManualBreaks(). This is useful when manual breaks are easier to communicate to a non-technical audience.
    -   Provides an applyto() method that allows the normalisr breask to be applied to different data. Useful when user wished to analyse howe normalised values have changed over time.
