#include <napi.h>

typedef struct TSLanguage TSLanguage;

extern "C" TSLanguage *tree_sitter_bicep();
extern "C" TSLanguage *tree_sitter_bicep_params();

// "tree-sitter", "language" hashed with BLAKE2
const napi_type_tag LANGUAGE_TYPE_TAG = {
    0x8AF2E5212AD58ABF, 0xD5006CAD83ABBA16
};

Napi::Object Init(Napi::Env env, Napi::Object exports) {
    auto bicep = Napi::Object::New(env);
    bicep["name"] = Napi::String::New(env, "bicep");
    auto bicep_language = Napi::External<TSLanguage>::New(env, tree_sitter_bicep());
    bicep_language.TypeTag(&LANGUAGE_TYPE_TAG);
    bicep["language"] = bicep_language;

    auto bicep_params = Napi::Object::New(env);
    bicep_params["name"] = Napi::String::New(env, "bicep_params");
    auto bicep_params_language = Napi::External<TSLanguage>::New(env, tree_sitter_bicep_params());
    bicep_params_language.TypeTag(&LANGUAGE_TYPE_TAG);
    bicep_params["language"] = bicep_params_language;

    exports["bicep"] = bicep;
    exports["bicep_params"] = bicep_params;
    return exports;
}

NODE_API_MODULE(tree_sitter_bicep_binding, Init)
