# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

null_mle_lreg <- function(XX, n, p, cons, a, b, sprob, niters) {
    .Call(`_BVSNLP_null_mle_lreg`, XX, n, p, cons, a, b, sprob, niters)
}

#' Non-parallel version of Bayesian variable selector for logistic regression
#' data using nonlocal priors
#' @description This function performs Bayesian variable selection for
#' logistic regression data in a non-parallel fashion. It does not contain any
#' pre-processing step or variable initialization. Moreover it does not have
#' the feature to be run in parallel for performing the coupling algorithm.
#' Therefore in general, it is NOT recommended to be used unless the user
#' knows how to initialize all the parameters. However, this function is
#' called by \code{\link{bvs}} function, the recommended way to run Bayesian
#' variable selection for such datasets.
#' @param exmat An extended matrix where the first column is binary resonse
#' vector and the rest is the design matrix which has its first column all 1
#' to account for the intercept in the model and is the output of
#' \code{PreProcess} code where the fixed columns are moved to the beginning.
#' @param chain1 The first chain or initial model where the MCMC algorithm
#' starts from. Note that the first \code{nf+1} elements are \code{1} where
#' \code{nf} is the number of fixed covariates that do not enter the selection
#' procedure and \code{1} is for the intercept.
#' @param nf The number of fixed covariates that do not enter the selection
#' procedure.
#' @param tau The paramter \code{tau} of the iMOM prior.
#' @param r The paramter \code{r} of the iMOM prior.
#' @param nlptype Determines the type of nonlocal prior that is used in the
#' analyses. \code{0} is for piMOM and \code{1} is for pMOM.
#' @param a The first parameter in beta distribution used as prior on model
#' size. This parameter is equal to 1 when uinform-binomial prior is used.
#' @param b The second paramter in beta distribution used as prior on model
#' size. This parameter is equal to 1 when uinform-binomial prior is used.
#' @param in_cons The average model size. This value under certain conditions
#' and when \code{p} is large, is equal to parameter \code{a} of the
#' beta-binomial prior.
#' @param loopcnt Number of iterations for MCMC procedure.
#' @param cplng A boolean variable indicating the coupling algorithm to be
#' performed or not.
#' @param chain2 Second chain or model for starting the MCMC procedure. This
#' parameter is only used when \code{cplng=TRUE}. Thus, it could be simply
#' set to \code{chain1} when it is not used.
#'
#' @return It returns a list containing following objects:
#' \item{max_chain}{A \code{1} by \code{p+1} binary vector showing the selected
#' model with maximum probability. \code{1} means a specific variable is
#' selected. The first variable is always the intercept.}
#' \item{beta_hat}{The coefficient vector for the selected model. The first one
#'  is always for the intercept.}
#' \item{max_prop}{The unnormalized probability of the model with highest
#' posterior probability.}
#'  \item{num_iterations}{The number of MCMC iterations that are executed.
#'  This is used when \code{cplng=TRUE} to check whether the total designated
#'  MCMC iterations were used or two chains are coupled sooner than that.}
#' \item{cplng_flag}{This is used when \code{cplng=TRUE} and indicates whether
#' two chains are coupled or not.}
#' \item{num_vis_models}{Number of visited models in search for the highest
#' probability model. This contains redundant models too and is not the number
#' of unique models.}
#' \item{hash_key}{This is only used when \code{cplng = FALSE}. This is a
#' vector containing real numbers uniquely assigned to each model for
#' distinguishing them.}
#' \item{hash_prob}{This is only used when \code{cplng = FALSE}. This is a
#' vector of probabilities for each visited model.}
#' \item{vis_covs}{This is only used when \code{cplng = FALSE}. This is a
#' list where each element contains indices of covariates for each visited
#' model.}
#' @author Amir Nikooienejad
#' @references Nikooienejad, A., Wang, W., and Johnson, V. E. (2016). Bayesian
#' variable selection for binary outcomes in high dimensional genomic studies
#' using nonlocal priors. Bioinformatics, 32(9), 1338-1345.\cr\cr
#' Nikooienejad, A., Wang, W., and Johnson, V. E. (2017). Bayesian Variable
#' Selection in High Dimensional Survival Time Cancer Genomic Datasets using
#' Nonlocal Priors. arXiv preprint, arXiv:1712.02964.\cr\cr
#' Johnson, V. E., and Rossell, D. (2010). On the use of non-local prior
#' densities in Bayesian hypothesis tests. Journal of the Royal Statistical
#' Society: Series B (Statistical Methodology), 72(2), 143-170.\cr\cr
#' Johnson, V. E. (1998). A coupling-regeneration scheme for
#' diagnosing convergence in Markov chain Monte Carlo algorithms. Journal of
#' the American Statistical Association, 93(441), 238-248.
#' @seealso \code{\link{bvs}}
#' @examples
#' ### Initializing parameters
#' n <- 200
#' p <- 40
#' set.seed(123)
#' Sigma <- diag(p)
#' full <- matrix(c(rep(0.5, p*p)), ncol=p)
#' Sigma <- full + 0.5*Sigma
#' cholS <- chol(Sigma)
#' Beta <- c(-1.7,1.8,2.5)
#' X <- matrix(rnorm(n*p), ncol=p)
#' X <- X%*%cholS
#' colnames(X) <- paste("gene_",c(1:p),sep="")
#' beta <- numeric(p)
#' beta[c(1:length(Beta))] <- Beta
#' XB <- X%*%beta
#' probs <- as.vector(exp(XB)/(1+exp(XB)))
#' y <- rbinom(n,1,probs)
#' exmat <- cbind(y,X)
#' tau <- 0.5; r <- 1; a <- 3; b <- p-a; in_cons <- a;
#' loopcnt <- 100; cplng <- FALSE;
#' initProb <- in_cons/p
#'
#' ### Initializing Chains
#' schain <- p
#' while (schain > in_cons || schain == 0) {
#' chain1 <- rbinom(p, 1, initProb)
#'  schain <- sum(chain1)
#' }
#' chain1 <- as.numeric(c(1, chain1))
#' chain2 <- chain1
#' nlptype <- 0 ## PiMOM nonlocal prior
#' nf <- 0 ### No fixed columns
#'
#' ### Running the function
#' bvsout <- logreg_bvs(exmat,chain1,nf,tau,r,nlptype,a,b,in_cons,loopcnt,cplng,chain2)
#'
#' ### Number of visited models for this specific run:
#' bvsout$num_vis_models
#'
#' ### The selected model:
#' which(bvsout$max_chain > 0)
#'
#' ### Estimated coefficients:
#' bvsout$beta_hat
#'
#' ### The unnormalized probability of the selected model:
#' bvsout$max_prob
logreg_bvs <- function(exmat, chain1, nf, tau, r, nlptype, a, b, in_cons, loopcnt, cplng, chain2) {
    .Call(`_BVSNLP_logreg_bvs`, exmat, chain1, nf, tau, r, nlptype, a, b, in_cons, loopcnt, cplng, chain2)
}

lreg_coef_est <- function(exmat, mod_cols, tau, r, nlptype) {
    .Call(`_BVSNLP_lreg_coef_est`, exmat, mod_cols, tau, r, nlptype)
}

lreg_mod_prob <- function(exmat, mod_cols, tau, r, a, b, nlptype) {
    .Call(`_BVSNLP_lreg_mod_prob`, exmat, mod_cols, tau, r, a, b, nlptype)
}

null_mle_cox <- function(XX, n, p, cons, a, b, csr, niters) {
    .Call(`_BVSNLP_null_mle_cox`, XX, n, p, cons, a, b, csr, niters)
}

#' Non-parallel version of Bayesian variable selector for survival data using
#' nonlocal priors
#' @description This function performs Bayesian variable selection for
#' survival data in a non-parallel fashion. It runs modified S5 algorithm to
#' search the model space but since this is only on one CPU, the number of
#' visited models will not be large and therefore is NOT recommended for
#' high dimensional datasets. This function is called by \code{\link{bvs}}
#' function in a parllel fashion and therefore that function is recommended
#' to be used.
#'
#' @param exmat An extended matrix where the first two columns are survival
#' times and status, respectively and the rest is the design matrix which is
#' produced by \code{PreProcess} function.
#' @param cur_cols A vector containing indices of the initial model for
#' variable selector to start the S5 algorithm from. Note that the first
#' \code{nf} indices are \code{1} to \code{nf} where \code{nf} is the number
#' of fixed covariates that do not enter the selection procedure.
#' @param nf The number of fixed covariates that do not enter the selection
#' procedure.
#' @param tau The paramter \code{tau} of the iMOM prior.
#' @param r The paramter \code{r} of the iMOM prior.
#' @param nlptype Determines the type of nonlocal prior that is used in the
#' analyses. \code{0} is for piMOM and \code{1} is for pMOM. 
#' @param a The first parameter in beta distribution used as prior on model
#' size. This parameter is equal to 1 when uinform-binomial prior is used.
#' @param b The second paramter in beta distribution used as prior on model
#' size. This parameter is equal to 1 when uinform-binomial prior is used.
#' @param d This is the number of candidate covariates picked from top
#' variables with highest utility function value and used in S5 algorithm.
#' @param L Number of temperatures in S5 algorithm.
#' @param J Number of iterations at each temperature in S5 algorithm.
#' @param temps Vector of temperatuers used in S5 algorithm.
#'
#' @return It returns a list containing following objects:
#' \item{max_model}{A \code{1} by \code{p} binary vector showing the selected
#' model with maximum probability. \code{1} means a specific variable is
#' selected.}
#' \item{hash_key}{A column vector indicating the generated key for each model
#' that is used to track visited models and growing dictionary.}
#' \item{max_prob}{The unnormalized probability of the model with highest
#' posterior probability.}
#' \item{all_probs}{A vector containing unnormalized probabilities of all
#' visited models.}
#' \item{vis_covs_list}{A list containing the covariates in each visited model
#' in the stochastic search process.}
#' @author Amir Nikooienejad
#' @references Nikooienejad, A., Wang, W., and Johnson, V. E. (2017). Bayesian
#' Variable Selection in High Dimensional Survival Time Cancer Genomic
#' Datasets using Nonlocal Priors. arXiv preprint, arXiv:1712.02964.\cr\cr
#' Shin, M., Bhattacharya, A., and Johnson, V. E. (2017). Scalable
#' Bayesian variable selection using nonlocal prior densities in ultrahigh
#' dimensional settings. Statistica Sinica.\cr\cr
#' Johnson, V. E., and Rossell, D. (2010). On the use of non-local prior
#' densities in Bayesian hypothesis tests. Journal of the Royal Statistical
#' Society: Series B (Statistical Methodology), 72(2), 143-170.
#' @seealso \code{\link{bvs}}
#' @examples
#' ### Initializing the parameters
#' n <- 100
#' p <- 40
#' set.seed(123)
#' Sigma <- diag(p)
#' full <- matrix(c(rep(0.5, p*p)), ncol=p)
#' Sigma <- full + 0.5*Sigma
#' cholS <- chol(Sigma)
#' Beta <- c(-1.8, 1.2, -1.7, 1.4, -1.4, 1.3)
#' X = matrix(rnorm(n*p), ncol=p)
#' X = X%*%cholS
#' X <- scale(X)
#' beta <- numeric(p)
#' beta[c(1:length(Beta))] <- Beta
#' XB <- X%*%beta
#' sur_times <- rexp(n,exp(XB))
#' cens_times <- rexp(n,0.2)
#' times <- pmin(sur_times,cens_times)
#' status <- as.numeric(sur_times <= cens_times)
#' exmat <- cbind(times,status,X)
#' L <- 10; J <- 10
#' d <- 2 * ceiling(log(p))
#' temps <- seq(3, 1, length.out = L)
#' tau <- 0.5; r <- 1; a <- 6; b <- p-a
#' nlptype <- 0 ### PiMOM nonlocal prior
#' cur_cols <- c(1,2,3) ### Starting model for the search algorithm
#' nf <- 0 ### No fixed columns
#' 
#'### Running the Function
#' coxout <- cox_bvs(exmat,cur_cols,nf,tau,r,nlptype,a,b,d,L,J,temps)
#' 
#' ### The number of visited model for this specific run:
#' length(coxout$hash_key)
#' 
#'
#' ### The selected model:
#' which(coxout$max_model>0)
#'
#' ### The unnormalized probability of the selected model:
#' coxout$max_prob
#' 
cox_bvs <- function(exmat, cur_cols, nf, tau, r, nlptype, a, b, d, L, J, temps) {
    .Call(`_BVSNLP_cox_bvs`, exmat, cur_cols, nf, tau, r, nlptype, a, b, d, L, J, temps)
}

inc_prob_calc <- function(all_probs, vis_covs, p) {
    .Call(`_BVSNLP_inc_prob_calc`, all_probs, vis_covs, p)
}

cox_coef_est <- function(exmat, mod_cols, tau, r, nlptype) {
    .Call(`_BVSNLP_cox_coef_est`, exmat, mod_cols, tau, r, nlptype)
}

cox_mod_prob <- function(exmat, mod_cols, tau, r, a, b, nlptype) {
    .Call(`_BVSNLP_cox_mod_prob`, exmat, mod_cols, tau, r, a, b, nlptype)
}

aucBMA_logistic <- function(X_tr, y_tr, X_te, y_te, tau, r, nlptype, probs, models, k) {
    .Call(`_BVSNLP_aucBMA_logistic`, X_tr, y_tr, X_te, y_te, tau, r, nlptype, probs, models, k)
}

aucBMA_survival <- function(X_tr, TS_tr, X_te, TS_te, tau, r, nlptype, times, probs, models, k) {
    .Call(`_BVSNLP_aucBMA_survival`, X_tr, TS_tr, X_te, TS_te, tau, r, nlptype, times, probs, models, k)
}

