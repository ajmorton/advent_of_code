cc_library(
    name = "solutions",
    hdrs = ["prelude.hpp", "day_01.hpp", "day_02.hpp", "day_03.hpp", "day_04.hpp"],
    srcs = ["prelude.cpp", "day_01.cpp", "day_02.cpp", "day_03.cpp", "day_04.cpp"],
    visibility = ["//:__pkg__", "//test:__pkg__"],
    deps = ["@boost//:conversion", "@boost//:algorithm", "@boost//:uuid"],
)