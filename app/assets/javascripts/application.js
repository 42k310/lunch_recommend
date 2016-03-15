//= require jquery
//= require jquery_ujs

$(window).on("load", function () {
    $("li").on("click", function () {
        $("li.selected").removeClass("selected");
        $(this).addClass("selected");
        $('.contents div').hide(); // 二つの要素を非表示にする
        $("." + this.id).show(); // クリックされたボタンに対応する要素を表示する
    });
});

window.addEventListener("load", function () {
    $("#ans1_left").on("click", function () {
        var ans1_1 = $("#ans1_1").get(0); // エレメントを取得する
        $(function () {
            $("#answer1_type").attr("value", 1);
        });
        $("#ans_block1").css("visibility", "hidden");
        $("#ans_block2").css("visibility", "visible")
    });

    $("#ans1_right").on("click", function () {
        var ans1_2 = $("#ans1_2").get(0);
        $(function () {
            $("#answer1_type").attr("value", 2);
        });

        $("#ans_block1").css("visibility", "hidden");
        $("#ans_block2").css("visibility", "visible")
    });

    $("#ans2_left").on("click", function () {
        var ans2_1 = $("#ans2_1").get(0);
        $(function () {
            $("#answer2_type").attr("value", 1);
        });

        $("#ans_block2").css("visibility", "hidden");
        $("#ans_block3").css("visibility", "visible")
    });

    $("#ans2_right").on("click", function () {
        var ans2_2 = $("#ans2_2").get(0);
        $(function () {
            $("#answer2_type").attr("value", 2);
        });

        $("#ans_block2").css("visibility", "hidden");
        $("#ans_block3").css("visibility", "visible")
    });

    $("#ans3_left").on("click", function () {
        var ans3_1 = $("#ans3_1").get(0);
        $(function () {
            $("#answer3_type").attr("value", 1);
        });
    });

    $("#ans3_right").on("click", function () {
        var ans3_2 = $("#ans3_2").get(0);
        $(function () {
            $("#answer3_type").attr("value", 2);
        });
    });

});

$(function () {
    $(".food_pic").each(function () {
        $(this).find("li:gt(20)").each(function () {
            $(this).hide();
        });
        $(this).append('<p>» もっと見る</p>');
        $(this).find("p:last").click(function () {
            $(this).parent().find("li").show(400);
            $(this).remove();
        });
    });
});