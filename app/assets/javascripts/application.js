//= require jquery

$(window).on("load", function () {
    $("li").on("click", function () {
        $("li.selected").removeClass("selected");
        $(this).addClass("selected");
        $('.contents div').hide(); // 二つの要素を非表示にする
        $("." + this.id).show(); // クリックされたボタンに対応する要素を表示する
    });
});

window.addEventListener("load", function () {
    $("#ans1_1").on("click", function () {
        var ans1_1 = $("#ans1_1").get(0); // エレメントを取得する
        var ans1_1_ans = 1;
        $(function () {
            $("#answer1_type").attr("value", ans1_1_ans);
        });

        $("#ans_block1").css("visibility", "hidden");
        $("#ans_block2").css("visibility", "visible")
    });

    $("#ans1_2").on("click", function () {
        var ans1_2 = $("#ans1_2").get(0);
        var ans1_2_ans = 2;
        $(function () {
            $("#answer1_type").attr("value", ans1_2_ans);
        });

        $("#ans_block1").css("visibility", "hidden");
        $("#ans_block2").css("visibility", "visible")
    });

    $("#ans2_1").on("click", function () {
        var ans2_1 = $("#ans2_1").get(0);
        var ans2_1_ans = 1;
        $(function () {
            $("#answer2_type").attr("value", ans2_1_ans);
        });

        $("#ans_block2").css("visibility", "hidden");
        $("#ans_block3").css("visibility", "visible")
    });

    $("#ans2_2").on("click", function () {
        var ans2_2 = $("#ans2_2").get(0);
        var ans2_2_ans = 2;
        $(function () {
            $("#answer2_type").attr("value", ans2_2_ans);
        });

        $("#ans_block2").css("visibility", "hidden");
        $("#ans_block3").css("visibility", "visible")
    });

    $("#ans3_1").on("click", function () {
        var ans3_1 = $("#ans3_1").get(0);
        var ans3_1_ans = 1;
        $(function () {
            $("#answer3_type").attr("value", ans3_1_ans);
        });
    });

    $("#ans3_2").on("click", function () {
        var ans3_2 = $("#ans3_2").get(0);
        var ans3_2_ans = 2;
        $(function () {
            $("#answer3_type").attr("value", ans3_2_ans);
        });
    });

});