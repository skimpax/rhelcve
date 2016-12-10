<issueedit>
    <h3 class="text-primary">Edit Issue</h3>

    <div class="row">
        <form id="idform1" class="form-inline" onsubmit={ doSelectIssue } action="#">
            <div class="form-group">
                <label for="idtag">Issue Tag</label>
                <select id="idtag" class="form-control" name="id">
                    <option value="" disabled selected>No Issue yet</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary" disabled={ issues.length == 0}>Edit</button>
        </form>
    </div>
    <hr>
    <div class="row">
        <div if={ isLoading } class='loader center-block'>
            <!-- <img src='puff.svg' /> -->
            <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
        </div>

        <div class="alert alert-warning" if={ error }>{ error }</div>

        <div if={ isLoading == false } >
            <div if={ issue }>
                <form id="idform2" class="form" onsubmit={ doUpdateIssue } action="#">
                    <div class="form-group">
                        <label for="idissuetag">Issue Tag:</label>
                        <input id="idissuetag" type="text" class="form-control" name="tag" value={ issue.tag } disabled={ isdisabled } readonly>
                    </div>
                    <div class="form-group">
                        <label for="idlocked">Locked:</label>
                        <input type='hidden' value='off' name='locked'>
                        <input id="idlocked" data-toggle="toggle" type="checkbox" data-on="Locked" data-off="Unlocked" data-onstyle="danger" data-offstyle="success" name="locked" checked={ issue.locked } disabled={ isdisabled }>
                    </div>
                    <div class="form-group">
                        <input type="hidden" name="id" value={ issue.id }>
                    </div>

                    <virtual if={ isdisabled }>
                        <button type="button" class="btn btn-primary center-block" onclick={ goToEditableMode }>Edit</button>
                    </virtual>
                    <virtual if={ !isdisabled }>
                        <button type="submit" class="btn btn-success center-block">Apply</button>
                    </virtual>
                </form>
            </div>
            <div if={ issues == null || issues.length == 0 }>
                <div class="alert alert-info">No Issue found.</div>
            </div>
        </div>
    </div>

    <script>

        this.issues = null;
        this.issue = null;
        this.isLoading = false;
        this.error = null;
        this.isdisabled = false;

        var self = this;

        getFormData(form) {

            var unindexed_array = $(form).serializeArray();
            var indexed_array = {};

            $.map(unindexed_array, function(n, i){
                indexed_array[n['name']] = n['value'];
            });

            return indexed_array;
        }

        updateSelectOptionsList() {

            if (self.issues.length > 0) {

                $('#idtag').empty();
                $('#idtag').append(
                    $.map(self.issues, function(el, i) {
                        return $('<option>').val(el.id).text(el.tag)
                    })
                );
            }
        }

        goToEditableMode() {

            self.isdisabled = false;
            self.update();
            $('#idlocked').bootstrapToggle();
        }

        doSelectIssue() {

            var obj = self.getFormData('#idform1');
            console.log(obj);

            self.doApiGetIssueData(obj.id);
            $('#idlocked').bootstrapToggle();
        }

        doUpdateIssue() {

            var obj = self.getFormData('#idform2');
            console.log(obj);

            self.doApiPutRequest(obj);
        }

        doApiPutRequest(data) {

            // var apiurl = self.issueidapi;
            var apiurl = '/api/issues/' + data.id;

            self.isLoading = true;
            self.update();

            $.ajax({
                type: "PUT",
                url: apiurl,
                data: data,
                success: function(results) {
                    //console.log(results);
                    alert("Assignment successfuly done!");
                    //window.location.replace(self.triagepage);
                    //location.reload(true);
                }
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to send data to server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
            });
        }

        doApiGetAllIssues() {

            var apiurl = "/api/issues";
            // if (criteria !== null && 0 !== criteria.length) {
            //     apiurl += "?" + criteria;
            // }

            self.isLoading = true;
            self.issues = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issues = results.data;
                console.log(self.issues);
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update();
                self.updateSelectOptionsList();
            });
        }

        doApiGetIssueData(id) {

            var apiurl = "/api/issues/" + id;

            self.isLoading = true;
            self.issue = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issue = results.data[0];
                console.log(self.issue);
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
            });
        }

        self.on('mount', function(){

            self.doApiGetAllIssues();
        })

    </script>

</issueedit>
