<%@page import="com.tyrsa.JSONTree"%>
<%@page import="com.tyrsa.TreeRoot"%>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Splat Tree</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="style.css">

</head>
<body>
    <script>
        function openFolder(){
            var selected = document.getElementsByClassName("selected");
            var text = null;
            if(selected.length !== 0){
                text = selected[0].getElementsByTagName("div")[0].innerText;
                var form = document.getElementById("folder_form");
                document.getElementById('folder_name').value = text;
                form.submit();
            }
            else{
                alert("Вы не выбрали папку");
            }
        }
        function add(div) {
            var img = div.getElementsByTagName("img");
            if(img[0].id === "folder"){
                img[0].src = "/img/folder_selected.png"
            }
            else {
                img[0].src = "/img/docs_selected.png"
            }
        }
        function remove(div) {
            var tmp = div.getElementsByTagName('img');
            if(tmp[0].id === "folder"){
                tmp[0].src = "/img/folder.png"
            }
            else {
                tmp[0].src = "/img/docs.png"
            }
        }
        var clickHandler = function(e){
            var p = e.target;
            while (p !== null && !p.classList.contains("panel-body")){
                p = p.parentElement;
            }
            var selected = document.getElementsByClassName("selected");
            for (var i = 0; i < selected.length; i++){
                remove(selected[i]);
                selected[i].classList.remove("selected");
            }
            p.classList.add("selected");
            add(p);
        };
        window.addEventListener("keypress", function (e) {
            var key = e.which || e.keyCode;
            if (key === 13) {
                document.getElementsByClassName("selected")[0].dispatchEvent(new MouseEvent('dblclick', {
                    'view': window,
                    'bubbles': true,
                    'cancelable': true
                }));
            }
        });
        window.addEventListener("dblclick",function(e){
            e.preventDefault();
            var selected = document.getElementsByClassName("selected");
            var img = selected[0].getElementsByTagName('img');
            img[0].src = "/img/loader.gif";
            setTimeout(openFolder, 2000);
        });
        window.addEventListener("keydown",function(e){
            if(e.code === "ArrowDown" || e.code === "ArrowUp"){
                //e.preventDefault();
                var selected = document.getElementsByClassName("selected");
                var doc = document.getElementById("file-list");
                if(selected !== null && selected.length !== 0 ){
                    var array = doc.getElementsByClassName("panel");
                    var i;
                    var found = false;
                    for(i = 0; i < array.length; i++){
                        elem = array[i].getElementsByClassName("selected");
                        if(elem.length !== 0){
                            found = true;
                            break;
                        }
                    }
                    if(found){
                        if(e.code === "ArrowDown" && i !== (array.length - 1)){
                            elem = array[i].getElementsByClassName("selected");
                            remove(elem[0]);
                            elem[0].classList.remove("selected");
                            div = array[i+1].getElementsByClassName("panel-body")[0];
                            add(div);
                            div.classList.add("selected")
                        }
                        else if(e.code === "ArrowUp" && i !== 0){
                            var elem = array[i].getElementsByClassName("selected");
                            remove(elem[0]);
                            elem[0].classList.remove("selected");
                            div = array[i-1].getElementsByClassName("panel-body")[0];
                            add(div);
                            div.classList.add("selected")
                        }
                    }
                }
                else {
                    var div = document.getElementsByClassName("panel-body")[0];
                    add(div);
                    div.classList.add("selected");
                }
            }
        })
    </script>
    <h1>
        О всех ошибках, допущенных при написании приложения, просьба сообщить на <b>stas.tyrsa@gmail.com</b><br>
        Заранее Спасибо!
    </h1>
    <h2>
        Путь к файлу tree.json: user.home\tree.json.<br>
        При удалении файла tree.json, файл будет создан автоматически. <br>
        Используйте Arrow Up, Arrow Down, Enter для навигации. <br>
        Используйте Mouse Click для выделения элемента и Mouse Double Click для перехода к содержимому элемента. <br>
    </h2>
    <br/>
    <form id="button_form" action="/tree_action" method="post">
    <div class="file-list" id="file-list"></div>
    <br><br><br><br><br>
        Имя для добавления/редактирования<br>
        <input id="name_field" type="text" name="name_field"><br>
        <input id="dir_radio" type="radio" name="file_type" value="directory" checked>Каталог<br>
        <input type="radio" name="file_type" value="file">Файл<br>
        <button type="submit" id="add_elem" name="button" value="add_button">Добавить элемент</button>
    </form>
    <div class="loader"></div>
    <button type="submit" id="edit_elem" name="button" value="edit_button">Изменить элемент</button>
    <button type="submit" id="del_elem" name="button" value="remove_buton">Удалить элемент</button>
    <button type="submit" id="select_elem" name="button" value="select_button">Вырезать элемент</button>
    <button type="submit" id="paste_elem" name="button" value="paste_button">Вставить элемент</button>
        <script>
            document.getElementById('del_elem').onclick = function () {
                var selected = document.getElementsByClassName("selected");
                var text = null
                if(selected.length !== 0){
                    text = selected[0].getElementsByTagName("div")[0].innerText;
                    var form = document.getElementById("del_form");
                    document.getElementById('del_name').value = text;
                    form.submit();
                }
                else{
                    alert("Вы не выбрали файл");
                }
            };
            document.getElementById('edit_elem').onclick = function () {
                var selected = document.getElementsByClassName("selected");
                var text = null
                if(selected.length != 0){
                    text = selected[0].getElementsByTagName("div")[0].innerText;
                    var form = document.getElementById("edit_form");
                    var checked = document.getElementById("dir_radio").checked
                    var newname = document.getElementById("name_field").value
                    document.getElementById('edit_name').value = text;
                    document.getElementById('new_name').value = newname;
                    document.getElementById('dir').value = checked;
                    form.submit();
                }
                else{
                    alert("Вы не выбрали файл");
                }
            };
            document.getElementById('select_elem').onclick = function () {
                var selected = document.getElementsByClassName("selected");
                if(selected.length !== 0){
                    var form = document.getElementById("select_form");
                    var text = selected[0].getElementsByTagName("div")[0].innerText;
                    document.getElementById("selected_name").value = text;
                    form.submit();
                }
            };
            document.getElementById('paste_elem').onclick = function () {
                var form = document.getElementById("paste_form");
                document.getElementById("paste_name").value = "paste";
                form.submit();
            };

            var list = document.getElementById("file-list");
            list.innerHTML = "";
            function printTree(text, dir) {
                var panelDiv = document.createElement("div");
                panelDiv.classList.add("panel");
                var panelBody = document.createElement("div");
                panelBody.classList.add("panel-body");
                var p = document.createElement("div");
                p.setAttribute("style", "font-weight: bold");
                p.innerText = text;
                panelBody.onclick = clickHandler;

                var img = document.createElement("img");
                if(dir === "true"){
                    img.setAttribute("src","/img/folder.png");
                    img.id = 'folder'
                }
                else{
                    img.setAttribute("src","/img/docs.png");
                    img.id = 'file'
                }
                panelBody.appendChild(img);
                panelBody.appendChild(p);
                panelDiv.appendChild(panelBody);
                list.appendChild(panelDiv);
            }
        </script>
    <%
        JSONTree[] tree = (JSONTree[]) request.getAttribute("message");
        if(tree == null){
            tree = TreeRoot.getRoot();
        }
        if(tree.length != 0){
            %><script>
                var list = document.getElementById("file-list");
                list.innerHTML = ""
            </script><%
            for(JSONTree obj : tree) {
                String name = obj.getName();
                boolean isDir = obj.isDirectory();
                %><script>printTree("<%=name%>", "<%=isDir%>")</script><%
            }
        }
    %>


    <script type="text/javascript">
       if("<%=request.getAttribute("getAlert")%>" !== "null"){
          alert("<%=request.getAttribute("getAlert")%>");
       }
    </script>


    <form id="folder_form" action="/tree_action" method="post">
        <input type="hidden" id="folder_name" name="folder_name"/>
    </form>
    <form id="del_form" action="/tree_action" method="post">
        <input type="hidden" id="del_name" name="del_name"/>
    </form>
    <form id="edit_form" action="/tree_action" method="post">
        <input type="hidden" id="edit_name" name="edit_name"/>
        <input type="hidden" id="new_name" name="new_name" />
        <input type="hidden" id="dir" name="dir" />
    </form>
    <form id="select_form" action="/tree_action" method="post">
        <input type="hidden" id="selected_name" name="selected_name"/>
    </form>
    <form id="paste_form" action="/tree_action" method="post">
        <input type="hidden" id="paste_name" name="paste_name"/>
    </form>


</body>
</html>