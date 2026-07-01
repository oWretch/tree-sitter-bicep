fn main() {
    let root_dir = std::path::Path::new(".");
    let bicep_dir = root_dir.join("bicep").join("src");
    let bicep_params_dir = root_dir.join("bicep_params").join("src");
    let common_dir = root_dir.join("common");

    let mut config = cc::Build::new();
    config.include(&bicep_dir);
    config
        .flag_if_supported("-std=c11")
        .flag_if_supported("-Wno-unused-parameter");

    #[cfg(target_env = "msvc")]
    config.flag("-utf-8");

    for path in &[
        bicep_dir.join("parser.c"),
        bicep_dir.join("scanner.c"),
        bicep_params_dir.join("parser.c"),
        bicep_params_dir.join("scanner.c"),
    ] {
        config.file(path);
        println!("cargo:rerun-if-changed={}", path.to_str().unwrap());
    }

    println!(
        "cargo:rerun-if-changed={}",
        common_dir.join("scanner.h").to_str().unwrap()
    );

    config.compile("tree-sitter-bicep");
}
