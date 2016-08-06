function [class_model, solver_info] = ptn_sedumi_solve_id_05(ptn_info, pen_digit_case)

t0 = cputime;
[formulate_form_sedumi] = ptn_formulate_sedumi_05(ptn_info, pen_digit_case);
t1 = cputime;
solver_info.formulate_cpusec = t1 - t0;

pars.maxiter = ptn_info.algo_max_iter;
pars.bigeps = ptn_info.algo_bigeps;
[x, y, info] = sedumi(formulate_form_sedumi.A, formulate_form_sedumi.b, formulate_form_sedumi.c, formulate_form_sedumi.K, pars);
[Model_Ord2] = ptn_construct_model_05(ptn_info.N, ptn_info.dim_feature, x);
class_model.class_id = ptn_info.model_class_id;
class_model.Model_Ord2 = Model_Ord2;

info.cpusec = info.cpusec + solver_info.formulate_cpusec;
solver_info.solution_info = info;
solver_info.m = size(formulate_form_sedumi.b);
solver_info.n = size(formulate_form_sedumi.c);
solver_info.x = x;
solver_info.y = y;