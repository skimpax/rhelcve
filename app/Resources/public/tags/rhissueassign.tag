<issueassign>
    <h3 class="text-primary">Issue Assignment</h3>

<!--     <div>
        <h4>Search Criteria</h4>
        <form id="myform1" class="form-inline" onsubmit={ doSubmit } action="#">
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div id="iddatepicker" class="input-group date" data-provide="datepicker">
                    <input id="dateafter" type="text" class="form-control" name="after">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </div>
                </div>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div> -->

    <div class="row">
        <form id="idform1" class="form-inline" onsubmit={ doSelectIssue } action="#">
                <h5>Select the Issue Tag you will assign triaged errata</h5>
            <div class="form-group">
                <label for="idselissue">Issue Tag: </label>
                <select id="idselissue" class="form-control" name="issueid">
                </select>
            </div>
            <button type="submit" class="btn btn-primary" disabled={ issues.length == 0}>Select</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <h5>Triaged (accepted) errata not assigned to any issue yet:</h5>
        <div if={ errata.length }>
            <br>
            <div row>
                <div class="col-md-6 col-md-offset-3"">
                    <table id="assigntable" class="table table-striped table-bordered" width="100%" cellspacing="0" disabled={ applyable != true }>
                        <thead>
                            <tr>
                                <th>Errata</th>
                                <th>Assign</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr each="{ value, i in errata }">
                                <td>{ value.errata }</td>
                                <td>
                                    <input class="cerrata" data-errataid={ value.id } data-toggle="toggle" type="checkbox" data-on="Assign" data-off="Not Assigned" data-onstyle="success" data-offstyle="info" name="assign_{ value.errata }">
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <a class="btn btn-success" onclick={ doApplyAssign } href="#" role="button" disabled={ applyable != true }>Apply</a>
                </div>
            </div>
        </div>
        <div if={ errata == null || errata.length == 0 }>
            <div class="alert alert-info">No unassigned accepted errata found.</div>
        </div>
    </div>

    <script>

        this.errata = [];
        this.selissueid = null;
        this.isLoading = false;
        this.error = null;
        this.applyable = false;

        var self = this

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

                $('#idselissue').empty();
                $('#idselissue').append(
                    $.map(self.issues, function(el, i) {
                        return $('<option>').val(el.id).text(el.tag)
                    })
                );
            }
        }

        getErrataToAssign() {

            var toassign = [];
            var elems = document.getElementsByClassName("cerrata");
            for (i = 0; i < elems.length; i++) {
                if (elems[i].checked) {
                    toassign.push(elems[i].dataset.errataid);
                }
            }
            return toassign;
        }

        doSelectIssue() {

            var obj = self.getFormData('#idform1');
            self.selissueid = obj.issueid;
            self.applyable = true;
        }

        doApplyAssign() {

            var errataids = self.getErrataToAssign();
            // console.log(errataids);

            if (errataids.length > 0) {
                var triageids = { 'triageids': errataids };
                this.doApiPostAssignment(self.selissueid, triageids);
            }
            else {
                self.error = "No errata checked for assignment!";
            }
        }

        doApiPostAssignment(issueid, data) {

            //var apiurl = self.issueidapi;
            var apiurl =  "/api/issues/" + issueid + "/errata";

            self.isLoading = true;
            self.error = null;
            self.update();

            $.post(apiurl, data, function(results) {
                //console.log(results);
                alert("Errata ssignment successfuly done!");
                //window.location.replace(self.triagepage);
                //location.reload(true);
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

        doApiGetAssignable() {

            var apiurl = "/api/issues/unlocked";
            self.isLoading = true;
            self.error = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issues = results.data;
                //console.log(results.data);
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
                self.updateSelectOptionsList();
            });


            apiurl = "/api/triaged/accepted";
  
            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.errata = results.data;
                //console.log(results.data);
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
                // $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('#iddatepicker').datepicker({
                autoclose: true,
                clearBtn: true,
                weekStart: 1,
                format: 'yyyy-mm-dd'
            });

            self.doApiGetAssignable();
        })

    </script>

</issueassign>
