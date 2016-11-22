<rheltriage>
    <h3 class="text-primary">CVRF List</h3>

    <div>
        <h4>Search Criteria  <small>in Red Hat security DB</small></h4>
        <form id="myform1" class="form-inline" onsubmit={ doRhelGrab } action="#">
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div class="input-group date" data-provide="datepicker" data-date-format="yyyy-mm-dd">
                    <input id="dateafter" type="text" class="form-control" name="after" required>
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-th"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="idseverity">Severity:</label>
                <select id="idseverity" class="form-control" name="severity" required>
                    <option value="critical">Critical</option>
                    <option value="important">Important</option>
                    <option value="moderate">Moderate</option>
                    <option value="low">Low</option>
                </select>
            </div>
            <div class="form-group">
                <label for="idrhelversion">RHEL Version:</label>
                <select id="idrhelversion" class="form-control" name="rhelversion" required>
                    <option value="v7">7.x</option>
                    <option value="v6" disabled>6.x</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <!-- <td>#{ i }</td> -->
                        <td>{ value.released_on }</td>
                        <td>{ value.RHSA }</td>
                        <td>{ value.severity }</td>
                        <td>{ value.released_packages }</td>
                        <td><a href="{ convert2htmllink(value.resource_url) }">link</a></td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
        </div>
    </div>


    <script>

        this.items = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2htmllink(jsonlink) {

            // https://access.redhat.com/documentation/en/red-hat-security-data-api/version-0.1/red-hat-security-data-api/
            // remove '.json' in URL to get link hat will return data in plain HTML 
            return jsonlink.replace(/\.json$/, ".xml");
        }

        doRhelGrab() {

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiRequest(criteria = null) {

            var apiurl = "/api/rheltriage";
            if (criteria !== null && 0 !== criteria.length) {
                apiurl += "?" + criteria;
            }
            console.log(apiurl);

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                console.log(results);
                self.items = results.data;
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
                $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('.datepicker').datepicker({
                format: 'yyyy/mm/dd',
                startDate: '-1m'
            });

            // doApiRequest();
        })

    </script>

</rheltriage>
