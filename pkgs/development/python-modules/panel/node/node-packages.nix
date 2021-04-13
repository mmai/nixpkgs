# This file has been generated by node2nix 1.9.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@bokeh/bokehjs-2.3.0" = {
      name = "_at_bokeh_slash_bokehjs";
      packageName = "@bokeh/bokehjs";
      version = "2.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@bokeh/bokehjs/-/bokehjs-2.3.0.tgz";
        sha512 = "geKBhYUVJ5IaY0UNk9k2P0yiYLCj+DOeNjdDneuTJ8K5R9fs0Rpp4iiaQKUGr1yUyQHGHLU8sk4CFZ+Bd5ZILg==";
      };
    };
    "@bokeh/numbro-1.6.2" = {
      name = "_at_bokeh_slash_numbro";
      packageName = "@bokeh/numbro";
      version = "1.6.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@bokeh/numbro/-/numbro-1.6.2.tgz";
        sha512 = "owIECPc3T3QXHCb2v5Ez+/uE9SIxI7N4nd9iFlWnfBrOelr0/omvFn09VisRn37AAFAY39sJiCVgECwryHWUPA==";
      };
    };
    "@bokeh/slickgrid-2.4.2702" = {
      name = "_at_bokeh_slash_slickgrid";
      packageName = "@bokeh/slickgrid";
      version = "2.4.2702";
      src = fetchurl {
        url = "https://registry.npmjs.org/@bokeh/slickgrid/-/slickgrid-2.4.2702.tgz";
        sha512 = "W9tm8Qdw5BrylbZbaVWaQMgLfW/klesnj6J3FnyWpo18hCCOFApccUD8iOnRv7bF6PHlgWk84mW3JT5RSzYKjA==";
      };
    };
    "@luma.gl/constants-8.4.4" = {
      name = "_at_luma.gl_slash_constants";
      packageName = "@luma.gl/constants";
      version = "8.4.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/@luma.gl/constants/-/constants-8.4.4.tgz";
        sha512 = "4e58QW6UKXkxiIvWSLoAnTc4cT8nvb0PhLzu1h8KiCuaDT5Vq8csOymcNOy/jhpfcIhHlmT1KwowF5m/DcOlKg==";
      };
    };
    "@types/debounce-1.2.0" = {
      name = "_at_types_slash_debounce";
      packageName = "@types/debounce";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/debounce/-/debounce-1.2.0.tgz";
        sha512 = "bWG5wapaWgbss9E238T0R6bfo5Fh3OkeoSt245CM7JJwVwpw6MEBCbIxLq5z8KzsE3uJhzcIuQkyiZmzV3M/Dw==";
      };
    };
    "@types/gl-matrix-2.4.5" = {
      name = "_at_types_slash_gl-matrix";
      packageName = "@types/gl-matrix";
      version = "2.4.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/gl-matrix/-/gl-matrix-2.4.5.tgz";
        sha512 = "0L8Mq1+oaIW0oVzGUDbSW+HnTjCNb4CmoIQE5BkoHt/A7x20z0MJ1PnwfH3atty/vbWLGgvJwVu2Mz3SKFiEFw==";
      };
    };
    "@types/jquery-3.5.5" = {
      name = "_at_types_slash_jquery";
      packageName = "@types/jquery";
      version = "3.5.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/jquery/-/jquery-3.5.5.tgz";
        sha512 = "6RXU9Xzpc6vxNrS6FPPapN1SxSHgQ336WC6Jj/N8q30OiaBZ00l1GBgeP7usjVZPivSkGUfL1z/WW6TX989M+w==";
      };
    };
    "@types/sizzle-2.3.2" = {
      name = "_at_types_slash_sizzle";
      packageName = "@types/sizzle";
      version = "2.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/sizzle/-/sizzle-2.3.2.tgz";
        sha512 = "7EJYyKTL7tFR8+gDbB6Wwz/arpGa0Mywk1TJbNzKzHtzbwVmY4HR9WqS5VV7dsBUKQmPNr192jHr/VpBluj/hg==";
      };
    };
    "@types/slickgrid-2.1.30" = {
      name = "_at_types_slash_slickgrid";
      packageName = "@types/slickgrid";
      version = "2.1.30";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/slickgrid/-/slickgrid-2.1.30.tgz";
        sha512 = "9nTqNWD3BtEVK0CP+G+mBtvSrKTfQy3Dg5/al+GdTSVMHFm37UxsHJ1eURwPg7rYu6vc7xU95fGTCKMZbxsD5w==";
      };
    };
    "choices.js-9.0.1" = {
      name = "choices.js";
      packageName = "choices.js";
      version = "9.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/choices.js/-/choices.js-9.0.1.tgz";
        sha512 = "JgpeDY0Tmg7tqY6jaW/druSklJSt7W68tXFJIw0GSGWmO37SDAL8o60eICNGbzIODjj02VNNtf5h6TgoHDtCsA==";
      };
    };
    "d-1.0.1" = {
      name = "d";
      packageName = "d";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/d/-/d-1.0.1.tgz";
        sha512 = "m62ShEObQ39CfralilEQRjH6oAMtNCV1xJyEx5LpRYUVN+EviphDgUc/F3hnYbADmkiNs67Y+3ylmlG7Lnu+FA==";
      };
    };
    "debounce-1.2.1" = {
      name = "debounce";
      packageName = "debounce";
      version = "1.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/debounce/-/debounce-1.2.1.tgz";
        sha512 = "XRRe6Glud4rd/ZGQfiV1ruXSfbvfJedlV9Y6zOlP+2K04vBYiJEte6stfFkCP03aMnY5tsipamumUjL14fofug==";
      };
    };
    "deepmerge-4.2.2" = {
      name = "deepmerge";
      packageName = "deepmerge";
      version = "4.2.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/deepmerge/-/deepmerge-4.2.2.tgz";
        sha512 = "FJ3UgI4gIl+PHZm53knsuSFpE+nESMr7M4v9QcgB7S63Kj/6WqMiFQJpBBYz1Pt+66bZpP3Q7Lye0Oo9MPKEdg==";
      };
    };
    "es5-ext-0.10.53" = {
      name = "es5-ext";
      packageName = "es5-ext";
      version = "0.10.53";
      src = fetchurl {
        url = "https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.53.tgz";
        sha512 = "Xs2Stw6NiNHWypzRTY1MtaG/uJlwCk8kH81920ma8mvN8Xq1gsfhZvpkImLQArw8AHnv8MT2I45J3c0R8slE+Q==";
      };
    };
    "es6-iterator-2.0.3" = {
      name = "es6-iterator";
      packageName = "es6-iterator";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz";
        sha1 = "a7de889141a05a94b0854403b2d0a0fbfa98f3b7";
      };
    };
    "es6-map-0.1.5" = {
      name = "es6-map";
      packageName = "es6-map";
      version = "0.1.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-map/-/es6-map-0.1.5.tgz";
        sha1 = "9136e0503dcc06a301690f0bb14ff4e364e949f0";
      };
    };
    "es6-promise-4.2.8" = {
      name = "es6-promise";
      packageName = "es6-promise";
      version = "4.2.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-promise/-/es6-promise-4.2.8.tgz";
        sha512 = "HJDGx5daxeIvxdBxvG2cb9g4tEvwIk3i8+nhX0yGrYmZUzbkdg8QbDevheDB8gd0//uPj4c1EQua8Q+MViT0/w==";
      };
    };
    "es6-set-0.1.5" = {
      name = "es6-set";
      packageName = "es6-set";
      version = "0.1.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-set/-/es6-set-0.1.5.tgz";
        sha1 = "d2b3ec5d4d800ced818db538d28974db0a73ccb1";
      };
    };
    "es6-symbol-3.1.1" = {
      name = "es6-symbol";
      packageName = "es6-symbol";
      version = "3.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.1.tgz";
        sha1 = "bf00ef4fdab6ba1b46ecb7b629b4c7ed5715cc77";
      };
    };
    "es6-symbol-3.1.3" = {
      name = "es6-symbol";
      packageName = "es6-symbol";
      version = "3.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.3.tgz";
        sha512 = "NJ6Yn3FuDinBaBRWl/q5X/s4koRHBrgKAu+yGI6JCBeiu3qrcbJhwT2GeR/EXVfylRk8dpQVJoLEFhK+Mu31NA==";
      };
    };
    "es6-weak-map-2.0.3" = {
      name = "es6-weak-map";
      packageName = "es6-weak-map";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-2.0.3.tgz";
        sha512 = "p5um32HOTO1kP+w7PRnB+5lQ43Z6muuMuIMffvDN8ZB4GcnjLBV6zGStpbASIMk4DCAvEaamhe2zhyCb/QXXsA==";
      };
    };
    "event-emitter-0.3.5" = {
      name = "event-emitter";
      packageName = "event-emitter";
      version = "0.3.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/event-emitter/-/event-emitter-0.3.5.tgz";
        sha1 = "df8c69eef1647923c7157b9ce83840610b02cc39";
      };
    };
    "ext-1.4.0" = {
      name = "ext";
      packageName = "ext";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ext/-/ext-1.4.0.tgz";
        sha512 = "Key5NIsUxdqKg3vIsdw9dSuXpPCQ297y6wBjL30edxwPgt2E44WcWBZey/ZvUc6sERLTxKdyCu4gZFmUbk1Q7A==";
      };
    };
    "fast-deep-equal-2.0.1" = {
      name = "fast-deep-equal";
      packageName = "fast-deep-equal";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-2.0.1.tgz";
        sha1 = "7b05218ddf9667bf7f370bf7fdb2cb15fdd0aa49";
      };
    };
    "fast-json-patch-2.2.1" = {
      name = "fast-json-patch";
      packageName = "fast-json-patch";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/fast-json-patch/-/fast-json-patch-2.2.1.tgz";
        sha512 = "4j5uBaTnsYAV5ebkidvxiLUYOwjQ+JSFljeqfTxCrH9bDmlCQaOJFS84oDJ2rAXZq2yskmk3ORfoP9DCwqFNig==";
      };
    };
    "flatbush-3.3.0" = {
      name = "flatbush";
      packageName = "flatbush";
      version = "3.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/flatbush/-/flatbush-3.3.0.tgz";
        sha512 = "F3EzQvKpdmXUbFwWxLKBpytOFEGYQMCTBLuqZ4GEajFOEAvnOIBiyxW3OFSZXIOtpCS8teN6bFEpNZtnVXuDQA==";
      };
    };
    "flatpickr-4.6.9" = {
      name = "flatpickr";
      packageName = "flatpickr";
      version = "4.6.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/flatpickr/-/flatpickr-4.6.9.tgz";
        sha512 = "F0azNNi8foVWKSF+8X+ZJzz8r9sE1G4hl06RyceIaLvyltKvDl6vqk9Lm/6AUUCi5HWaIjiUbk7UpeE/fOXOpw==";
      };
    };
    "flatqueue-1.2.1" = {
      name = "flatqueue";
      packageName = "flatqueue";
      version = "1.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/flatqueue/-/flatqueue-1.2.1.tgz";
        sha512 = "X86TpWS1rGuY7m382HuA9vngLeDuWA9lJvhEG+GfgKMV5onSvx5a71cl7GMbXzhWtlN9dGfqOBrpfqeOtUfGYQ==";
      };
    };
    "fuse.js-3.6.1" = {
      name = "fuse.js";
      packageName = "fuse.js";
      version = "3.6.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/fuse.js/-/fuse.js-3.6.1.tgz";
        sha512 = "hT9yh/tiinkmirKrlv4KWOjztdoZo1mx9Qh4KvWqC7isoXwdUY3PNWUxceF4/qO9R6riA2C29jdTOeQOIROjgw==";
      };
    };
    "gl-matrix-3.3.0" = {
      name = "gl-matrix";
      packageName = "gl-matrix";
      version = "3.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/gl-matrix/-/gl-matrix-3.3.0.tgz";
        sha512 = "COb7LDz+SXaHtl/h4LeaFcNdJdAQSDeVqjiIihSXNrkWObZLhDI4hIkZC11Aeqp7bcE72clzB0BnDXr2SmslRA==";
      };
    };
    "hammerjs-2.0.8" = {
      name = "hammerjs";
      packageName = "hammerjs";
      version = "2.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/hammerjs/-/hammerjs-2.0.8.tgz";
        sha1 = "04ef77862cff2bb79d30f7692095930222bf60f1";
      };
    };
    "htm-3.0.4" = {
      name = "htm";
      packageName = "htm";
      version = "3.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/htm/-/htm-3.0.4.tgz";
        sha512 = "VRdvxX3tmrXuT/Ovt59NMp/ORMFi4bceFMDjos1PV4E0mV+5votuID8R60egR9A4U8nLt238R/snlJGz3UYiTQ==";
      };
    };
    "jquery-3.6.0" = {
      name = "jquery";
      packageName = "jquery";
      version = "3.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jquery/-/jquery-3.6.0.tgz";
        sha512 = "JVzAR/AjBvVt2BmYhxRCSYysDsPcssdmTFnzyLEts9qNwmjmu4JTAMYubEfwVOSwpQ1I1sKKFcxhZCI2buerfw==";
      };
    };
    "jquery-ui-1.12.1" = {
      name = "jquery-ui";
      packageName = "jquery-ui";
      version = "1.12.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/jquery-ui/-/jquery-ui-1.12.1.tgz";
        sha1 = "bcb4045c8dd0539c134bc1488cdd3e768a7a9e51";
      };
    };
    "js-tokens-4.0.0" = {
      name = "js-tokens";
      packageName = "js-tokens";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz";
        sha512 = "RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==";
      };
    };
    "json-formatter-js-2.3.4" = {
      name = "json-formatter-js";
      packageName = "json-formatter-js";
      version = "2.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-formatter-js/-/json-formatter-js-2.3.4.tgz";
        sha512 = "gmAzYRtPRmYzeAT4T7+t3NhTF89JOAIioCVDddl9YDb3ls3kWcskirafw/MZGJaRhEU6fRimGJHl7CC7gaAI2Q==";
      };
    };
    "loose-envify-1.4.0" = {
      name = "loose-envify";
      packageName = "loose-envify";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz";
        sha512 = "lyuxPGr/Wfhrlem2CL/UcnUc1zcqKAImBDzukY7Y5F/yQiNdko6+fRLevlw1HgMySw7f611UIY408EtxRSoK3Q==";
      };
    };
    "mgrs-1.0.0" = {
      name = "mgrs";
      packageName = "mgrs";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/mgrs/-/mgrs-1.0.0.tgz";
        sha1 = "fb91588e78c90025672395cb40b25f7cd6ad1829";
      };
    };
    "next-tick-1.0.0" = {
      name = "next-tick";
      packageName = "next-tick";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/next-tick/-/next-tick-1.0.0.tgz";
        sha1 = "ca86d1fe8828169b0120208e3dc8424b9db8342c";
      };
    };
    "nouislider-14.7.0" = {
      name = "nouislider";
      packageName = "nouislider";
      version = "14.7.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/nouislider/-/nouislider-14.7.0.tgz";
        sha512 = "4RtQ1+LHJKesDCNJrXkQcwXAWCrC2aggdLYMstS/G5fEWL+fXZbUA9pwVNHFghMGuFGRATlDLNInRaPeRKzpFQ==";
      };
    };
    "preact-10.5.13" = {
      name = "preact";
      packageName = "preact";
      version = "10.5.13";
      src = fetchurl {
        url = "https://registry.npmjs.org/preact/-/preact-10.5.13.tgz";
        sha512 = "q/vlKIGNwzTLu+jCcvywgGrt+H/1P/oIRSD6mV4ln3hmlC+Aa34C7yfPI4+5bzW8pONyVXYS7SvXosy2dKKtWQ==";
      };
    };
    "proj4-2.7.2" = {
      name = "proj4";
      packageName = "proj4";
      version = "2.7.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/proj4/-/proj4-2.7.2.tgz";
        sha512 = "x/EboBmIq48a9FED0Z9zWCXkd8VIpXHLsyEXljGtsnzeztC41bFjPjJ0S//wBbNLDnDYRe0e6c3FSSiqMCebDA==";
      };
    };
    "redux-4.0.5" = {
      name = "redux";
      packageName = "redux";
      version = "4.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/redux/-/redux-4.0.5.tgz";
        sha512 = "VSz1uMAH24DM6MF72vcojpYPtrTUu3ByVWfPL1nPfVRb5mZVTve5GnNCUV53QM/BZ66xfWrm0CTWoM+Xlz8V1w==";
      };
    };
    "sprintf-js-1.1.2" = {
      name = "sprintf-js";
      packageName = "sprintf-js";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz";
        sha512 = "VE0SOVEHCk7Qc8ulkWw3ntAzXuqf7S2lvwQaDLRnUeIEaKNQJzV6BwmLKhOqT61aGhfUMrXeaBk+oDGCzvhcug==";
      };
    };
    "symbol-observable-1.2.0" = {
      name = "symbol-observable";
      packageName = "symbol-observable";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/symbol-observable/-/symbol-observable-1.2.0.tgz";
        sha512 = "e900nM8RRtGhlV36KGEU9k65K3mPb1WV70OdjfxlG2EAuM1noi/E/BaW/uMhL7bPEssK8QV57vN3esixjUvcXQ==";
      };
    };
    "timezone-1.0.23" = {
      name = "timezone";
      packageName = "timezone";
      version = "1.0.23";
      src = fetchurl {
        url = "https://registry.npmjs.org/timezone/-/timezone-1.0.23.tgz";
        sha512 = "yhQgk6qmSLB+TF8HGmApZAVI5bfzR1CoKUGr+WMZWmx75ED1uDewAZA8QMGCQ70TEv4GmM8pDB9jrHuxdaQ1PA==";
      };
    };
    "tslib-1.14.1" = {
      name = "tslib";
      packageName = "tslib";
      version = "1.14.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz";
        sha512 = "Xni35NKzjgMrwevysHTCArtLDpPvye8zV/0E4EyYn43P7/7qvQwPh9BGkHewbMulVntbigmcT7rdX3BNo9wRJg==";
      };
    };
    "tslib-2.2.0" = {
      name = "tslib";
      packageName = "tslib";
      version = "2.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/tslib/-/tslib-2.2.0.tgz";
        sha512 = "gS9GVHRU+RGn5KQM2rllAlR3dU6m7AcpJKdtH8gFvQiC4Otgk98XnmMU+nZenHt/+VhnBPWwgrJsyrdcw6i23w==";
      };
    };
    "type-1.2.0" = {
      name = "type";
      packageName = "type";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/type/-/type-1.2.0.tgz";
        sha512 = "+5nt5AAniqsCnu2cEQQdpzCAh33kVx8n0VoFidKpB1dVVLAN/F+bgVOqOJqOnEnrhp222clB5p3vUlD+1QAnfg==";
      };
    };
    "type-2.5.0" = {
      name = "type";
      packageName = "type";
      version = "2.5.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/type/-/type-2.5.0.tgz";
        sha512 = "180WMDQaIMm3+7hGXWf12GtdniDEy7nYcyFMKJn/eZz/6tSLXrUN9V0wKSbMjej0I1WHWbpREDEKHtqPQa9NNw==";
      };
    };
    "underscore.template-0.1.7" = {
      name = "underscore.template";
      packageName = "underscore.template";
      version = "0.1.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/underscore.template/-/underscore.template-0.1.7.tgz";
        sha1 = "3013e0ea181756306f1609e959cafbc722adb3e9";
      };
    };
    "wkt-parser-1.2.4" = {
      name = "wkt-parser";
      packageName = "wkt-parser";
      version = "1.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/wkt-parser/-/wkt-parser-1.2.4.tgz";
        sha512 = "ZzKnc7ml/91fOPh5bANBL4vUlWPIYYv11waCtWTkl2TRN+LEmBg60Q1MA8gqV4hEp4MGfSj9JiHz91zw/gTDXg==";
      };
    };
  };
  args = {
    name = "_at_holoviz_slash_panel";
    packageName = "@holoviz/panel";
    version = "0.11.1";
    src = ./.;
    dependencies = [
      sources."@bokeh/bokehjs-2.3.0"
      sources."@bokeh/numbro-1.6.2"
      (sources."@bokeh/slickgrid-2.4.2702" // {
        dependencies = [
          sources."tslib-1.14.1"
        ];
      })
      sources."@luma.gl/constants-8.4.4"
      sources."@types/debounce-1.2.0"
      sources."@types/gl-matrix-2.4.5"
      sources."@types/jquery-3.5.5"
      sources."@types/sizzle-2.3.2"
      sources."@types/slickgrid-2.1.30"
      sources."choices.js-9.0.1"
      sources."d-1.0.1"
      sources."debounce-1.2.1"
      sources."deepmerge-4.2.2"
      sources."es5-ext-0.10.53"
      sources."es6-iterator-2.0.3"
      sources."es6-map-0.1.5"
      sources."es6-promise-4.2.8"
      (sources."es6-set-0.1.5" // {
        dependencies = [
          sources."es6-symbol-3.1.1"
        ];
      })
      sources."es6-symbol-3.1.3"
      sources."es6-weak-map-2.0.3"
      sources."event-emitter-0.3.5"
      (sources."ext-1.4.0" // {
        dependencies = [
          sources."type-2.5.0"
        ];
      })
      sources."fast-deep-equal-2.0.1"
      sources."fast-json-patch-2.2.1"
      sources."flatbush-3.3.0"
      sources."flatpickr-4.6.9"
      sources."flatqueue-1.2.1"
      sources."fuse.js-3.6.1"
      sources."gl-matrix-3.3.0"
      sources."hammerjs-2.0.8"
      sources."htm-3.0.4"
      sources."jquery-3.6.0"
      sources."jquery-ui-1.12.1"
      sources."js-tokens-4.0.0"
      sources."json-formatter-js-2.3.4"
      sources."loose-envify-1.4.0"
      sources."mgrs-1.0.0"
      sources."next-tick-1.0.0"
      sources."nouislider-14.7.0"
      sources."preact-10.5.13"
      sources."proj4-2.7.2"
      sources."redux-4.0.5"
      sources."sprintf-js-1.1.2"
      sources."symbol-observable-1.2.0"
      sources."timezone-1.0.23"
      sources."tslib-2.2.0"
      sources."type-1.2.0"
      sources."underscore.template-0.1.7"
      sources."wkt-parser-1.2.4"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "A high level dashboarding library for python visualization libraries.";
      license = "BSD-3-Clause";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
in
{
  args = args;
  sources = sources;
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
  nodeDependencies = nodeEnv.buildNodeDependencies (lib.overrideExisting args {
    src = stdenv.mkDerivation {
      name = args.name + "-package-json";
      src = nix-gitignore.gitignoreSourcePure [
        "*"
        "!package.json"
        "!package-lock.json"
      ] args.src;
      dontBuild = true;
      installPhase = "mkdir -p $out; cp -r ./* $out;";
    };
  });
}
