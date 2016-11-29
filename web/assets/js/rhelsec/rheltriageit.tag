<rheltriageit>
  
    <hr>

    <div if={ isLoading } class='loader center'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ data != null }>
            <h3>Errata Data</h3>
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
<!--                 <thead>
                    <tr>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </tfoot> -->
                <tbody>
                    <tr>
                        <td><b>RHSA</b></td>
                        <td>{ data.RHSA }</td>
                    </tr>
                    <tr>
                        <td><b>Released Date </b></td>
                        <td>{ data.released_on }</td>
                    </tr>
                    <tr>
                        <td><b>Severity</b></td>
                        <td>{ data.severity }</td>
                    </tr>
                    <tr>
                        <td><b>Note</b></td>
                        <td>{ data.note }</td>
                    </tr>
                    <tr>
                        <td><b>Packages</b></td>
                        <td>{ data.released_packages }</td>
                    </tr>
                    <tr>
                        <td><b>RHEL Link</b></td>
                        <td><a href="{ data.rhel_weblink }">link</a></td>
                    </tr>
                </tbody>
            </table>
            </div>
            </div>
            <hr>
            <h3>Triage Decision</h3>
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
                    <form id="myform1" class="form" onsubmit={ doSubmit } action="#">
                        <div class="form-group">
                            <label for="iddecision">Decision:</label>
                            <select id="iddecision" class="form-control" name="decision" required>
                                <option value="accept">Accept</option>
                                <option value="reject">Reject</option>
                                <option value="unknown">Don't Know</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="idcomment">Comment:</label>
                            <textarea id="idcomment" class="form-control" name="comment" placeholder="Some comment to explain the decision made" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="iddomain">Domain:</label>
                            <input type="text" class="form-control" name="domain" placeholder="Indicate domain this errata applies to">
                        </div>
                        <div class="form-group">
                            <label for="idpriority">Deploy Priority:</label>
                            <select id="idpriority" class="form-control" name="deploypri" required>
                                <option class="bg-danger" value="high">High</option>
                                <option class="bg-warning" value="medium">Medium</option>
                                <option class="bg-info" value="low">Low</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="idreboot">Reboot Required:</label>
                            <input id="idreboot" data-toggle="toggle" type="checkbox" data-on="Yes" data-off="No" data-onstyle="danger" data-offstyle="info" name="reboot">
                        </div>
                        <div class="form-group">
                            <input type="hidden" name="errata" value={ data.RHSA }>
                            <input type="hidden" name="erratadate" value={ data.released_on }>
                            <input type="hidden" name="user" value="clherieau">
                        </div>
                        <button type="submit" class="btn btn-success">Apply</button>
                    </form>
                </div>
            </div>
        </div>
        <div if={ data == null || data.length == 0 }>
            <div class="alert alert-info">No data received.</div>
        </div>
    </div>


    <script>

        this.cvrf = null;
        this.data = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        doSubmit() {

            var queryparams = $('#myform1').serialize();
            console.log(queryparams);
            // var queryparams = getFormData('#myform1');
            // var dat = JSON.stringify($('#myform1').serializeArray());
            //self.doApiPostRequest(self.cvrf, queryparams);
        }

        getFormData($form) {

            var unindexed_array = $form.serializeArray();
            var indexed_array = {};

            $.map(unindexed_array, function(n, i){
                indexed_array[n['name']] = n['value'];
            });

            return indexed_array;
        }

        doApiGetRequest(cvrf) {

            var apiurl = "/api/rheltriage/" + cvrf;

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                console.log(results.data);
                self.data = results.data;
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

        doApiPostRequest(cvrf, jsondata) {

            var apiurl = "/api/rheltriage/" + cvrf;

            self.isLoading = true;
            self.update();

            $.post(apiurl, JSON.stringify(jsondata), function(results) {
                console.log(results);
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

        self.on('mount', function() {

            $('#idreboot').bootstrapToggle();

            self.cvrf = opts.cvrf;
            self.doApiGetRequest(self.cvrf);
        })

    </script>

</rheltriageit>
