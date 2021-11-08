#' Lower 1-alpha Confidence Bound (Minimum Sum Method)
#'
#' Function obtained from Edwards et. al. (2003): "a bisection routine to find a lower 1-alpha confidence bound for Ne, the number of population items in error. Population size Npop, SRS size nsamp, ne = number of sample items in error.
#'
#' Citation: Edwards, D., Ward-Besser, G., Lasecki, J., Parker, B., Wu, F. & Moorhead, P. (2003).  The Minimum Sum Method: A Distribution-Free Sampling Procedure for Medicare Fraud Investigations.  Heath Services & Outcomes Research Methodology 4: 241-263.
#'
#' @param Npop "Number of payments (e.g. on Medicare claims) in the universe/population"
#' @param nsamp "Number of payments (e.g. on Medicare claims) in...simple random sample"
#' @param ne "The number...of sample payments which are completely in error (Or, for partial overpayment scenarios, seriously in error—see Section 4.2.)"
#' @param alpha alpha-level for "1-alpha confidence bound"
#'
#' @return Lower 1-alpha confidence bound for the "number...of universe payments which are completely in error (Or, for partial overpayment scenarios, seriously in error—see Section 4.2.)"
#' @export
#'
#' @examples
#' Ne_low(Npop = 1000, nsamp = 30, ne = 15, alpha=0.05)
Ne_low <- function(Npop, nsamp, ne, alpha=0.10)
{
  if(ne == 0) return(0) else {
    Na <- ne
    Pa <- (1-stats::phyper(ne - 1, Na, Npop - Na, nsamp))
    if(Pa >= alpha)
      return(ne)
    else {
      Nb <- Npop
      Pb <- 1
      while((Nb - Na) > 1) {
        Nnew <- trunc((Nb + Na)/2)
        Pnew <- (1-stats::phyper(ne - 1, Nnew, Npop - Nnew, nsamp))
        if(Pnew >= alpha) {
          Nb <- Nnew
          Pb <- Pnew
        }
        else {
          Na <- Nnew
          Pa <- Pnew
        }
      }
      if(Pa >= alpha)
        return(Na)
      else return(Nb)
    }
  }
}

#' Upper 1-alpha Confidence Bound (Minimum Sum Method)
#'
#' Function obtained from Edwards et. al. (2003): "a bisection routine to find an upper 1-alpha confidence bound for Ne, the number of population items in error. Population size Npop, SRS size nsamp, ne = number of sample items in error."
#'
#' Citation: Edwards, D., Ward-Besser, G., Lasecki, J., Parker, B., Wu, F. & Moorhead, P. (2003).  The Minimum Sum Method: A Distribution-Free Sampling Procedure for Medicare Fraud Investigations.  Heath Services & Outcomes Research Methodology 4: 241-263.
#'
#' @param Npop "Number of payments (e.g. on Medicare claims) in the universe/population"
#' @param nsamp "Number of payments (e.g. on Medicare claims) in...simple random sample"
#' @param ne "The number...of sample payments which are completely in error (Or, for partial overpayment scenarios, seriously in error—see Section 4.2.)"
#' @param alpha alpha-level for "1-alpha confidence bound"
#'
#' @return Upper 1-alpha confidence bound for the "number...of universe payments which are completely in error (Or, for partial overpayment scenarios, seriously in error—see Section 4.2.)"
#' @export
#'
#' @examples
#' Ne_up(Npop = 1000, nsamp = 30, ne = 15, alpha=0.05)
Ne_up <- function(Npop, nsamp, ne, alpha = 0.10)
{

  if(ne == nsamp) return(Npop) else {
    Nb <- Npop
    Pb <- stats::phyper(ne, Nb, Npop - Nb, nsamp)
    if(Pb >= alpha)
      return(Npop)
    else {
      Na <- ne
      Pa <- 1
      while((Nb - Na) > 1) {
        Nnew <- trunc((Nb + Na)/2)
        Pnew <- stats::phyper(ne, Nnew, Npop - Nnew, nsamp)
        if(Pnew >= alpha) {
          Na <- Nnew
          Pa <- Pnew
        }
        else {
          Nb <- Nnew
          Pb <- Pnew
        }
      }
      if(Pb >= alpha)
        return(Nb)
      else return(Na)
    }
  }
}

#'  Difference Between Ne_low ("lower bound for the number of population payments in error") and ne
#'
#' @param Npop "Number of payments (e.g. on Medicare claims) in the universe/population"
#' @param nsamp "Number of payments (e.g. on Medicare claims) in...simple random sample"
#' @param ne "The number...of sample payments which are completely in error (Or, for partial overpayment scenarios, seriously in error—see Section 4.2.)"
#' @param alpha alpha-level for "1-alpha confidence bound"
#'
#' @return Ne_low - ne
#' @export
#'
#' @examples
#' Ne_low_minus_ne(Npop = 1000, nsamp = 30, ne = 20)
Ne_low_minus_ne <- function(Npop, nsamp, ne, alpha=0.10){
  Ne_low(Npop, nsamp, ne, alpha) - ne
}

LMS <- function(df_samp,
                df_frame,
                var,
                sub_var,
                flag,
                Npop,
                nsamp,
                ne,
                alpha=0.10){

  #Convert column names to strings
  sub_var <- deparse(substitute(sub_var))
  var     <- deparse(substitute(var))
  flag     <- deparse(substitute(flag))

  #Remove samples from sampling frame
  frame_vec <- df_frame[[sub_var]]
  samp_vec <- df_samp[[sub_var]]
  df_frame <- df_frame[!(frame_vec %in% samp_vec), ]

  #Order sampling frame by var
  df_frame <- df_frame[order(df_frame[[var]]),]

  #Get LNE − ne
  LNe_ne <- Ne_low_minus_ne(Npop, nsamp, ne, alpha)

  #Get sampling frame with Ne_low_minus_ne rows removed
  df_frame <- df_frame[1:LNe_ne, , drop = FALSE]

  #Get "sum of the smallest LNE − nE nonsampled population payments"
  sum_LNe_ne <- sum(df_frame[[var]])

  #Get sum of the nE sample overpayments
  remove <- df_samp
  df_samp <- df_samp[df_samp[[flag]] == 1, ]
  sum_ne <- sum(df_samp[[var]])

  LMS_out <- sum_ne + sum_LNe_ne


  Output <- list("LMS" = LMS_out, "sum_ne" = sum_ne, "sum_LNE_minus_ne" = sum_LNe_ne)

  return(Output)
}
