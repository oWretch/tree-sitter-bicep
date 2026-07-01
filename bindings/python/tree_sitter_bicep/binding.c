#include <Python.h>

typedef struct TSLanguage TSLanguage;

TSLanguage *tree_sitter_bicep(void);
TSLanguage *tree_sitter_bicep_params(void);

static PyObject* _binding_language_bicep(PyObject *Py_UNUSED(self), PyObject *Py_UNUSED(args)) {
    return PyCapsule_New(tree_sitter_bicep(), "tree_sitter.Language", NULL);
}

static PyObject* _binding_language_bicep_params(PyObject *Py_UNUSED(self), PyObject *Py_UNUSED(args)) {
    return PyCapsule_New(tree_sitter_bicep_params(), "tree_sitter.Language", NULL);
}

static PyMethodDef methods[] = {
    {"language_bicep", _binding_language_bicep, METH_NOARGS,
     "Get the tree-sitter language for Bicep."},
    {"language_bicep_params", _binding_language_bicep_params, METH_NOARGS,
     "Get the tree-sitter language for Bicep Params."},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    .m_base = PyModuleDef_HEAD_INIT,
    .m_name = "_binding",
    .m_doc = NULL,
    .m_size = -1,
    .m_methods = methods
};

PyMODINIT_FUNC PyInit__binding(void) {
    return PyModule_Create(&module);
}
