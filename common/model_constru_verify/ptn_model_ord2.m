function class = ptn_model_ord2(feature, Model_Ord2)

class = feature * Model_Ord2.ModelMatrix * feature' + feature *Model_Ord2.ModelLinearVec + Model_Ord2.ModelOffset;
