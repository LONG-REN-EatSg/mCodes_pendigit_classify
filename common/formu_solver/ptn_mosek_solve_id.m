function [class_model, solver_info] = ptn_mosek_solve_id(ptn_info, pen_digit_case)

t0 = cputime;
[formulate_form_mosek] = ptn_formulate_mosek_01(ptn_info, pen_digit_case);
t1 = cputime;
solver_info.formulate_cpusec = t1 - t0;
formulate_cpusec = t1 - t0

param.MSK_IPAR_LOG_HEAD = 0;
param.MSK_IPAR_LOG = 0;
param.MSK_IPAR_MIO_MAX_NUM_BRANCHES = ptn_info.algo_max_iter;
%pars.bigeps = ptn_info.algo_bigeps;
[r, res] = mosekopt('minimize', formulate_form_mosek, param);

[Model_Ord2] = ptn_constr_model_mosek(ptn_info.N, ptn_info.dim_feature, res.sol.itr.xx);
class_model.class_id = ptn_info.model_class_id;
class_model.Model_Ord2 = Model_Ord2;

t2 = cputime;
solver_info.solution_cpusec = t2 - t1;
solution_cpusec = t2 - t1

solver_info.cpusec = solver_info.solution_cpusec + solver_info.formulate_cpusec;
solver_info.m = size(formulate_form_mosek.blc);
solver_info.n = size(formulate_form_mosek.c);
solver_info.x = res.sol.itr.xx';
